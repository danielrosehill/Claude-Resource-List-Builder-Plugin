---
name: reorganise-resource-list
description: Use when the user wants an existing resource list re-categorised — sections renamed/merged/split, entries re-bucketed, or the whole table re-alphabetised. Triggers — "reorganise the <topic> list", "the sections on this list have grown messy", "split <section> into two", "re-bucket these entries". Non-destructive — proposes the reshape first.
---

# Reorganise Resource List

Restructure an existing resource list — section scheme, ordering, or both. Always propose changes before writing.

## Procedure

1. **Read the target README.** Inventory current sections and entries.
2. **Diagnose.** Look for:
   - Sections with one or two entries (candidates for merge).
   - A single section with >20 entries (candidate for split).
   - Mis-bucketed entries (description/topics don't match the section).
   - Sections out of alphabetical order.
   - Duplicate entries across sections.
3. **Propose a plan** to the user as a short diff:
   - Renames: `Old → New`
   - Splits: `Big Section → [Sub A, Sub B]` with which entries land where.
   - Merges: `[X, Y] → Combined`
   - Moves: list each entry → new section.
   - Pure alphabetisation runs (no scheme change) can be applied without proposal.
4. **Wait for approval.** If the user says "go" or names specific changes from the plan, execute. Otherwise iterate on the plan.
5. **Execute the reshape.** Rewrite the README with:
   - **Sections in alphabetical order.**
   - **Rows alphabetical by display name within each section.**
   - Updated Contents TOC.
   - Same Project|Description|Stars table format. Don't refetch metadata unless the user asks.
6. **Commit and push.**
   - `git add -A && git commit -m "Reorganise: <short summary>"`
   - `git push`
7. **Report.** What moved, what merged, what was renamed.

## Edge cases

- **Star-count or activity-based reshape** — not this skill's job; that's `analyze-resource-list`. Suggest the user run that first if their goal is pruning.
- **User wants a totally new section scheme** — fine, but ask them to either name the new sections or hand over a topic list. Don't invent a scheme silently.
- **Cross-list reshape** (move entries from list A to list B) — handle as two operations: remove from A (commit), then `update-resource-list` to add to B.
