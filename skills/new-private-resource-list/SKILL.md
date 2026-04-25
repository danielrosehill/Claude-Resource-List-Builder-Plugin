---
name: new-private-resource-list
description: Use when the user wants to scaffold a new PRIVATE GitHub resource list (internal-only index of third-party repos). Triggers — "new private resource list", "create a private list of...", "internal-only list of repos for X", "private awesome list of Y". Produces the canonical README shape (alphabetical sections, project/description/stars/last-updated table, scope block, sources used). Private repo on GitHub. For public lists use `new-resource-list`.
---

# New Resource List (Private)

Scaffold a new private GitHub resource list following Daniel's standard shape. Standalone — does not depend on the public skill.

## Inputs to gather (silently infer where possible)

1. **Topic / scope** — what the list catalogues (e.g. "internal eval tooling shortlist", "private OSINT tooling for client X").
2. **Repo name** — Train-Case (e.g. `Internal-Eval-Tooling-Shortlist`, `OSINT-Tools-Private`). Confirm with the user only if ambiguous. Avoid the `Awesome-` prefix on private lists unless the user requests it.
3. **Initial entries** — URLs the user dropped. May be zero (scope-only scaffold).
4. **Section scheme** — either user-provided or AI-proposed from the entries. If proposing, list the sections back to the user before writing.
5. **Discovery sources (optional)** — GitHub topic URLs or awesome lists used to find entries. Captured as Sources Used (see below).

## Standard shape (the default)

Everything below is the default — only deviate if the user explicitly asks.

- Filename: `README.md` at repo root.
- Short scope block: **In Scope** / **Out Of Scope** bullets.
- **Sources Used** block when the user supplied GitHub topic URLs or other discovery sources. Placement: **1–3 sources** render inline near the top, immediately under the scope block. **4+ sources** render in a `## Sources Used` section at the bottom (just above List Authorship) so they don't crowd out the recommendations.
- **Contents** TOC linking to each section.
- **Sections in alphabetical order.** Within each section, **rows alphabetical by display name.**
- Each section is a 4-column table — **Stars and Last Updated are mandatory**, never dropped:

  ```markdown
  | Project | Description | Stars | Last Updated |
  |---|---|---|---|
  | [Display Name](https://github.com/OWNER/REPO) | One-sentence description (≤22 words). | ![](https://img.shields.io/github/stars/OWNER/REPO?style=social) | ![](https://img.shields.io/github/last-commit/OWNER/REPO) |
  ```

- Display name = human-readable (`DeepEval`, not `deepeval`). Description from `gh repo view OWNER/REPO --json description -q .description`, trimmed to ≤22 words. No marketing tone.
- Footer: **List Authorship** with author block. **No CC0 badge.** License footer: omit CC0; use "All rights reserved." or honour `RESOURCE_LIST_PRIVATE_LICENSE` if set.
- Author block: "Curated by Daniel Rosehill." **No public-website link** by default.

## Procedure

1. **Resolve repo path.** Default to `~/repos/github/my-repos/<RepoName>`. Honour `RESOURCE_LIST_PRIVATE_BASE` env var if set.
2. **Resolve template.** If `RESOURCE_LIST_TEMPLATE_PATH` is set and points to a readable file, use it as the base instead of the built-in template below; still apply alphabetical ordering and the mandatory Stars + Last Updated columns.
3. **Fetch metadata** for every supplied URL in parallel: `gh repo view OWNER/REPO --json description,stargazerCount,pushedAt` (Bash, batched). Skip dead/missing repos and report them. Capture `pushedAt` and `stargazerCount` for the release-resource-list CSV export.
4. **Categorise.** If the user gave sections, use them verbatim. Otherwise propose a section list (alphabetical) covering the entries, and confirm with the user only if the entries span clearly different sub-domains. If the user dropped a flat list and asked for help organising, do the categorisation work — that is the value-add of this skill.
5. **Write README.md** using the shape above. Alphabetise sections. Alphabetise rows within each section.
6. **Initial commit + create GitHub repo (private).**
   - `git init` if not already.
   - `git add -A && git commit -m "Initial commit: <topic> resource list (private)"`
   - `gh repo create danielrosehill/<RepoName> --private --source=. --description "<one-line>" --push`
   - Private creation does not need explicit authorisation; public/private confusion is the bigger risk — if there's any signal the user might have wanted public, **ask once** before creating.
7. **Optional index registration.** If `RESOURCE_LIST_PRIVATE_INDEX` is set, offer to add a pointer there using its existing format. Do not auto-edit without confirmation. If unset, ask whether to register anywhere.
8. **Report.** Repo URL, visibility (private), entry count, sections used, anything skipped.

## Built-in README template

```markdown
# <Title>

[![View on GitHub](https://img.shields.io/badge/View%20on-GitHub-181717?logo=github&logoColor=white)](https://github.com/danielrosehill/<RepoName>)

<One-paragraph description of the list and its scope.>

## Scope

### In Scope
- ...

### Out Of Scope
- ...

{If 1–3 GitHub topic URLs / discovery sources were supplied, render here as a single line:
**Sources Used:** [topic-slug](https://github.com/topics/topic-slug) · [topic-slug](https://github.com/topics/topic-slug)
If 4+ sources, omit here and render the `## Sources Used` section near the bottom instead.}

---

## Contents

- [<Section A>](#section-a)
- [<Section B>](#section-b)

---

## <Section A>

| Project | Description | Stars | Last Updated |
|---|---|---|---|
| [Project Name](https://github.com/OWNER/REPO) | Description ≤22 words. | ![](https://img.shields.io/github/stars/OWNER/REPO?style=social) | ![](https://img.shields.io/github/last-commit/OWNER/REPO) |

## <Section B>

| Project | Description | Stars | Last Updated |
|---|---|---|---|

---

{If 4+ GitHub topic URLs were supplied as sources, render the section below; otherwise omit.}

## Sources Used

This list was assembled by surveying the following GitHub topic pages and awesome lists:

- [<topic-slug>](https://github.com/topics/<topic-slug>)
- ...

---

# List Authorship

## List Author

Curated by Daniel Rosehill.

## License

All rights reserved. Linked projects retain their own licenses.
```

## Edge cases

- **No entries supplied** — write a scope-only scaffold with empty section tables. Still create the repo.
- **Mixed Git hosts** — only GitHub repos get the star and last-commit badges. For GitLab/Codeberg/etc., render the cells as `—`.
- **Org URLs** — list each notable repo separately rather than the org root.
- **Existing repo at the target path** — stop and report; do not overwrite.
- **User accidentally invokes this skill for a list that should be public** — if you spot signs (clearly public-interest topic, no client/internal markers), confirm public/private once before pushing. A wrong public/private choice is hard to fully reverse.
