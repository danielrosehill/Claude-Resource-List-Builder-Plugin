---
name: update-resource-list
description: Add GitHub repos, Hugging Face models/datasets/Spaces or web links to an existing resource list, categorised, deduped and alphabetised in the list's own format (table or cards). Triggers: "add these to <list>", "update the <topic> list with...", "fold these into the list".
---

# Update Resource List

Read `${CLAUDE_PLUGIN_ROOT}/reference/entries.md` first (profile, URL classes, metadata, formats).

1. **Resolve the list** (named repo, or inferred; search `base_dir` / `private_base_dir` from the profile). Pull first.
2. **Read the README**: section scheme, format (table or cards), existing entries for dedup.
3. **Per URL, in parallel:** classify (github / hf model, dataset, space / web). Skip duplicates (same id anywhere in the README) and report them. Fetch metadata; flag dead/gated ones and skip.
4. **Categorise** into existing sections by topics/tags/pipeline_tag and description; respect user-supplied labels. Propose before creating a new section (write its description if `section_descriptions`). If a batch would add more than 2 new sections, ask.
5. **Insert** in the list's format, alphabetical within the section: tables use the matching header (GitHub vs Model/Dataset/Space columns; add a separate table under the section if the other source type has no table yet); cards use the card templates. Honour `show_stars` / `show_last_updated` as the list does; if the list is on the legacy 3-column shape and the profile wants Last Updated, upgrade the whole table and say so.
6. Update the Contents TOC if sections changed; add a description to any section lacking one when `section_descriptions` is true.
7. **Commit and push**: `Add: <short list>`; stage only the README (and SCOPE.md if touched).
8. **Report**: entry -> section, duplicates, dead URLs, push result.

Edge cases: an entry in two sections goes in the most specific (mention the alternative); descriptions truncate at a sentence boundary, never "...".
