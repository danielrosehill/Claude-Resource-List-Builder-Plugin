---
name: analyze-resource-list
description: Use when the user wants quality/health analysis of an existing resource list — flag stale repos, low-star entries, dead links, or surface what's worth pruning. Triggers — "audit the <topic> list", "find stale entries in...", "filter out repos under N stars that haven't been updated", "what should I cut from this list".
---

# Analyze Resource List

Run a health/quality pass over an existing resource list. Read-only by default — only mutates the list if the user approves a pruning plan.

## Default thresholds (override per request)

- **Low stars:** < 50
- **Stale:** no commit in > 18 months
- **Dead:** repo 404s, archived, or moved without redirect

## Procedure

1. **Read the README** and extract every `OWNER/REPO` link.
2. **Fetch metadata in parallel** for each entry:

   ```bash
   gh repo view OWNER/REPO --json stargazerCount,pushedAt,isArchived,description -q '{s:.stargazerCount,p:.pushedAt,a:.isArchived,d:.description}'
   ```

   For 404s, mark dead.
3. **Bucket the entries:**
   - `dead` — 404, moved, or archived with no successor.
   - `stale` — last push older than the staleness threshold.
   - `low-star` — below the star threshold AND not flagged as a niche/early-stage exception by the user.
   - `description-drift` — current GitHub description differs significantly from what the README says.
   - `healthy` — passes all checks.
4. **Render a report** as a markdown table sorted worst-first. Include section, project, stars, last push, flag(s).
5. **Optionally write the report** to `outputs/<list-name>-audit-<YYYY-MM-DD>.md` in the list repo if the user wants it kept.
6. **Offer a pruning plan** — list of removals + section renames the user could apply. Wait for explicit approval before mutating the README.
7. **If approved, execute the prune** — drop rows, update Contents TOC, commit:
   - `git add -A && git commit -m "Audit prune: <N removed, N updated>"`
   - `git push`

## What this skill does NOT do

- Doesn't auto-remove anything without confirmation.
- Doesn't refetch descriptions to overwrite the README — that's a deliberate `update-resource-list` decision.
- Doesn't judge "quality" beyond the mechanical stars/staleness/archive signals. A 12-star repo from a known author may be exactly what the user wants to keep.

## Edge cases

- **Rate limits** — if `gh` starts throttling, switch to sequential fetches with a small sleep, or batch via `gh api graphql`.
- **Forks** — flag forks as a separate bucket; some lists deliberately link to canonical sources, others to active forks.
- **Mirrors / moved repos** — surface the new location and let the user decide.
