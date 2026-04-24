---
name: update-resource-list
description: Use when the user drops one or more GitHub URLs into an existing resource list and wants them categorised, deduped, and added in the standard table format. Triggers — "add these to <list>", "update the <topic> list with…", "fold these repos into the eval list". The AI does the categorisation work — that is the value-add. Works on any list scaffolded by `new-resource-list` / `new-private-resource-list` (or any list using the same Project|Description|Stars table shape).
---

# Update Resource List

Add new entries to an existing resource list with AI-driven categorisation.

## Procedure

1. **Resolve the target list.** Either the user names the repo, or infer from the conversation. Confirm path. Default search root: `~/repos/github/my-repos/`.
2. **Read the current README** to learn the section scheme, table format, and existing entries (for dedup).
3. **For each new URL** (in parallel via Bash):
   - Skip if `OWNER/REPO` already appears anywhere in the README — note it as a duplicate.
   - `gh repo view OWNER/REPO --json description,stargazerCount,topics -q '{d:.description,s:.stargazerCount,t:.topics}'`
   - If the repo is dead/missing, flag it and skip.
4. **Categorise** each entry into one of the existing sections.
   - Use repo topics + description to pick the best fit.
   - If an entry doesn't fit any existing section, propose either (a) placing it in the closest section, or (b) creating a new section. Show the user the proposal before adding a brand-new section.
   - This is the value-add: when the user dumps a flat list, do the sifting work.
5. **Insert rows** in the correct table, preserving alphabetical order by display name within the section. Use the standard row format:

   ```markdown
   | [Display Name](https://github.com/OWNER/REPO) | One-sentence description (≤22 words). | ![](https://img.shields.io/github/stars/OWNER/REPO?style=social) |
   ```

   Display name = human-readable, not the raw repo slug. Description trimmed to ≤22 words.
6. **Update the Contents TOC** if any new section was added (re-alphabetise it).
7. **Commit and push.**
   - `git add -A && git commit -m "Add: <comma-separated short list>"`
   - `git push`
8. **Report.** Per-entry: name → section. Duplicates skipped. Dead URLs. Push confirmation.

## When the user provides their own categorisation

If the user pre-labels entries (`X goes under Y`), respect that without re-classifying. Still fetch metadata, dedupe, alphabetise the row insert, and use the standard format.

## Edge cases

- **Entry belongs in two sections** — pick the most specific one. Mention the alternative in the report.
- **Section explosion** — if you'd add >2 new sections from one batch, stop and ask the user whether to expand the section scheme or fit entries into existing buckets.
- **Description has a ≤22-word hard limit** — truncate at a sentence boundary and end with a period; do not append "...".
- **Non-GitHub entries** — render the stars cell as `—`.
