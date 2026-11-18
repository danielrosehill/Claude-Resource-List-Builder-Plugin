---
name: new-resource-list
description: Scaffold a new resource list (Awesome-style index of GitHub repos, Hugging Face models/datasets/Spaces, and web links) as a GitHub repo, public or private, with README, optional SCOPE.md, optional parent hub and index-of-indexes registration. Triggers: "create a resource list for X", "new index of Y", "new awesome list", "new private list".
---

# New Resource List

Read `${CLAUDE_PLUGIN_ROOT}/reference/entries.md` first and follow it (profile, URL classes, metadata, formats, ordering).

## Inputs (infer silently where possible)
1. Topic and scope. 2. Repo name per the profile `naming` convention (add `Awesome-` only if it fits). 3. Initial entries (may be zero). 4. Sections: user-given, or propose from entries and proceed. 5. Visibility: from the request ("private"), else `default_visibility`. 6. Format: request, else `formats.third_party` / `formats.own_repos`. 7. Optional parent hub: a name from `hubs` in the profile, or a given repo.

## Procedure
1. **Profile and paths.** Resolve the profile. Local dir = `base_dir/<RepoName>` (`private_base_dir` for private lists if set; the user may name another dir). Stop if it already exists.
2. **Metadata** for all entries in parallel (GitHub via `gh`, HF via `curl`). Skip and report dead ones.
3. **Categorise** into alphabetical sections; write a one or two sentence description per section when `section_descriptions` is true.
4. **Write README.md** from `paths.sh template README.md`: `top_badge` line (if set) above the title; description; "Part of" back-links (below); scope line linking SCOPE.md when `scope_file`; sections via `section.md` and the entry templates; Sources Used (1-3 inline under the scope line, 4+ as a section near the bottom); Contributing block with `contribution_line` and the licence badge. For a private list, skip the Contributing block and licence footer when `private_footer` is false; keep them if `private_footer: true`. Author name/url appear in Contributing only if set.
5. **SCOPE.md** (when `scope_file: true`, the default) from `paths.sh template SCOPE.md`: In scope, Out of scope, inclusion test; write real content from the topic. Include a "Part of" line if there is a parent.
6. **Back-links.** Collect lines to put near the top of README and SCOPE.md:
   - `index_of_indexes.repo` set and `register: true`: the `back_link_line`.
   - Parent hub: `Part of the [<Hub>](https://github.com/<hub repo>) index.`
7. **Create and push.** `git init`, commit `Initial commit: <topic> resource list`, `gh repo create <github_owner>/<RepoName> --public|--private --source=. --description "<one line>" --push`. No confirmation step for public repos: visibility comes from the profile or the request.
8. **Register in the index of indexes** (if configured and `register: true`): in its local clone (pull first; if absent, `gh repo clone`), add an entry in its `entry_format` (template `entry-cards-index-of-indexes.md` for cards), keeping alphabetical order, commit, push. Skip private lists unless the user asks.
9. **Register in the parent hub** (if given): in the hub's local clone, add an entry under its configured `section`: a card from the entry template when the hub sets `entry_format: cards`, else a row from `row_format`; keep alphabetical order; commit, push. Then best effort: for each sibling the hub lists whose README has a "Part of" line, add a one-line cross-link to the new list, commit and push each. Report every file changed; skip siblings that fail.
10. **Report**: repo URL, entry count, sections, back-links added, hub/index commits, skipped items.

## Edge cases
- No entries: scope-only scaffold, empty sections omitted.
- Org URLs: list notable repos separately.
- Web/paper links: no badge.
