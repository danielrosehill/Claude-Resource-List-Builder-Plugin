---
name: reorganise-resource-list
description: Re-categorise an existing resource list: rename, merge or split sections, move entries, re-alphabetise, add missing section descriptions, or convert between table and cards. Triggers: "reorganise the <topic> list", "split <section>", "the sections got messy", "convert this list to cards".
---

# Reorganise Resource List

Read `${CLAUDE_PLUGIN_ROOT}/reference/entries.md` first.

1. Read the README; detect its format (table or cards) and whether entries are GitHub, HF or web.
2. Diagnose: sections with 1-2 entries (merge), more than 20 (split), mis-bucketed entries, out-of-order sections or rows, duplicates, sections without descriptions when `section_descriptions` is true.
3. Propose a short plan (renames, splits, merges, moves, format conversion). Pure alphabetisation and adding missing descriptions can be applied without proposal. Wait for approval otherwise.
4. Rewrite the README: sections alphabetical, rows alphabetical, TOC updated, descriptions present, same format (or the converted one, with columns/badges following `show_stars` and `show_last_updated`; refetch metadata only when converting needs it, e.g. HF badges are URL-only so none is needed).
5. Commit `Reorganise: <summary>` and push. Report what moved.

Pruning by stars/staleness belongs to `analyze-resource-list`; moving entries between lists is remove (commit) then `update-resource-list`.
