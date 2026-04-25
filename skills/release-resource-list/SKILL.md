---
name: release-resource-list
description: Use when the user wants to cut a release of a resource list — a dated CSV snapshot of every entry with current star counts and last-pushed dates, plus a GitHub Release. Triggers — "release the <list>", "snapshot the <list>", "tag a release of <list>", "export the list as CSV", "freeze the current state of <list>". Works on any list scaffolded by `new-resource-list` / `new-private-resource-list` (Project|Description|Stars|Last Updated table shape).
---

# Release Resource List

Cut a dated, machine-readable snapshot of a resource list and publish it as a GitHub Release. The CSV is the canonical artefact — readers/agents downstream consume it instead of scraping the README.

## When to use

- User explicitly asks for a release / snapshot / CSV export.
- After a significant batch of additions via `update-resource-list`.
- On a cadence (quarterly is typical) to capture star/last-pushed drift over time.

## Inputs to gather

1. **Target list** — repo path or name. Default search root: `~/repos/github/my-repos/`. Confirm before running if ambiguous.
2. **Release tag** — default `release-YYYY-MM-DD` (today's date). Honour user-supplied semver (`v1.2.0`) if given.
3. **Release notes** — auto-generated summary by default (entry count, sections, deltas vs. previous release if one exists). User can override.

## Procedure

### 1. Locate and parse the README

- Read the README of the target list.
- Extract every row from every section table. Each row yields: `section`, `display_name`, `owner/repo`, `description`, `url`.
- Skip non-GitHub rows (where the badge cells were rendered as `—`) but include them in the CSV with empty star/last-updated fields and a `host` column noting the platform.

### 2. Re-fetch live metadata in parallel

For every `OWNER/REPO`:

```bash
gh api repos/OWNER/REPO --jq '{stars:.stargazers_count, last_pushed:.pushed_at, archived:.archived, language:.language, license:.license.spdx_id, homepage:.homepage, topics:.topics}'
```

Batch in parallel. Cache the JSON. Flag any repo that 404s (deleted/renamed) — include it in the CSV with `status=missing` and surface it in the report.

### 3. Write the CSV

Path: `releases/<tag>/entries.csv` inside the resource-list repo.

Required columns (in this order):

```
section,display_name,owner_repo,url,description,stars,last_pushed,archived,language,license,topics,homepage,status
```

- `last_pushed` — ISO-8601 (`2026-04-25T12:34:56Z`).
- `topics` — semicolon-separated.
- `status` — `ok`, `archived`, `missing`, or `non-github`.
- Rows alphabetised first by `section`, then by `display_name`. Headers exactly as above.
- Use proper CSV quoting (RFC 4180): wrap any field containing comma, quote, or newline in double quotes; escape internal quotes by doubling.

Also write `releases/<tag>/manifest.json` alongside it:

```json
{
  "tag": "release-2026-04-25",
  "generated_at": "2026-04-25T12:34:56Z",
  "list_repo": "danielrosehill/<RepoName>",
  "entry_count": 87,
  "sections": ["Section A", "Section B", "..."],
  "csv": "entries.csv"
}
```

### 4. Compute deltas (if a previous release exists)

- Find the most recent prior release directory under `releases/`.
- Compare prior `entries.csv` to the new one:
  - **Added**: entries in new but not prior.
  - **Removed**: entries in prior but not new.
  - **Star delta**: top 5 movers by absolute change.
  - **Newly archived / newly missing**: `status` flipped.
- Emit `releases/<tag>/CHANGES.md` with these sections.

### 5. Commit and tag

```bash
git add releases/<tag>/
git commit -m "Release <tag>: <entry_count> entries"
git tag <tag>
git push && git push --tags
```

### 6. Create the GitHub Release

```bash
gh release create <tag> \
  releases/<tag>/entries.csv \
  releases/<tag>/manifest.json \
  --title "<RepoName> — <tag>" \
  --notes-file releases/<tag>/CHANGES.md
```

If no `CHANGES.md` exists (first release), generate notes inline:

```bash
gh release create <tag> \
  releases/<tag>/entries.csv \
  releases/<tag>/manifest.json \
  --title "<RepoName> — <tag>" \
  --notes "First release. <entry_count> entries across <section_count> sections."
```

For **private** lists, the release is private by default (gh inherits repo visibility). Confirm before publishing if there is any ambiguity.

### 7. Report

- Local CSV path
- Release URL
- Entry count, section count
- Deltas summary (added / removed / top star movers / newly archived)
- Any 404s or non-GitHub entries that needed manual handling

## Edge cases

- **No prior releases** — skip delta computation; produce a "first release" notes file.
- **Renamed repos** — `gh api` follows redirects and returns the new `full_name`. If it differs from the README slug, flag it in the report and offer to run `update-resource-list` to fix the README.
- **Private list, public release** — never. Release visibility must match repo visibility unless the user explicitly overrides.
- **Stale README, fresh CSV** — the CSV is authoritative for the snapshot moment; do not edit the README from this skill. If the user wants the README badges refreshed, that's a no-op (shields.io is live) — but if the description text needs work, route to `update-resource-list`.
- **Very large lists (>500 entries)** — batch the `gh api` calls in groups of ~50 with `xargs -P` or similar; warn the user that the run will take a few minutes.
