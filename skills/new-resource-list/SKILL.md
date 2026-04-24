---
name: new-resource-list
description: Use when the user wants to scaffold a new PUBLIC GitHub resource list (Awesome-style index of third-party repos). Triggers — "create a resource list for X", "new awesome list", "let's build a list of Y tools/repos". Produces the canonical README shape (alphabetical sections, project/description/stars table, scope block, CC0). Public repo on GitHub. For private lists use `new-private-resource-list`.
---

# New Resource List (Public)

Scaffold a new public GitHub resource list following Daniel's standard shape.

## Inputs to gather (silently infer where possible)

1. **Topic / scope** — what the list catalogues (e.g. "AI evaluation tools", "Israeli civic-tech repos").
2. **Repo name** — Train-Case, prefixed `Awesome-` if it fits the genre. Examples: `Awesome-AI-Evaluations-Tools`, `LLM-Memory-Layers-Index`. Confirm with the user only if ambiguous.
3. **Initial entries** — URLs the user dropped. May be zero (scope-only scaffold).
4. **Section scheme** — either user-provided or AI-proposed from the entries. If proposing, list the sections back to the user before writing.

## Standard shape (the default)

Everything below is the default — only deviate if the user explicitly asks.

- Filename: `README.md` at repo root.
- Awesome badge at the top.
- Short scope block: **In Scope** / **Out Of Scope** bullets.
- Optional **Discovery sources** block (GitHub topic pages, awesome lists scraped, etc.) when the user provided them.
- **Contents** TOC linking to each section.
- **Sections in alphabetical order.** Within each section, **rows alphabetical by display name.**
- Each section is a 3-column table:

  ```markdown
  | Project | Description | Stars |
  |---|---|---|
  | [Display Name](https://github.com/OWNER/REPO) | One-sentence description (≤22 words). | ![](https://img.shields.io/github/stars/OWNER/REPO?style=social) |
  ```

- Display name = human-readable (`DeepEval`, not `deepeval`). Description from `gh repo view OWNER/REPO --json description -q .description`, trimmed to ≤22 words. No marketing tone.
- Footer: **List Authorship** with author block + **CC0** license badge.

## Procedure

1. **Resolve repo path.** Default to `~/repos/github/my-repos/<RepoName>` (Daniel's convention). Honour `RESOURCE_LIST_PUBLIC_BASE` env var if set.
2. **Resolve template.** If `RESOURCE_LIST_TEMPLATE_PATH` is set and points to a readable file, use it as the base instead of the built-in template below; still apply alphabetical ordering.
3. **Fetch metadata** for every supplied URL in parallel: `gh repo view OWNER/REPO --json description,stargazerCount` (Bash, batched). Skip dead/missing repos and report them.
4. **Categorise.** If the user gave sections, use them verbatim. Otherwise propose a section list (alphabetical) covering the entries, and confirm with the user only if the entries span clearly different sub-domains. If the user dropped a flat list and asked for help organising, do the categorisation work — that is the value-add of this skill.
5. **Write README.md** using the shape above. Alphabetise sections. Alphabetise rows within each section.
6. **Initial commit + create GitHub repo.**
   - `git init` if not already.
   - `git add -A && git commit -m "Initial commit: <topic> resource list"`
   - `gh repo create danielrosehill/<RepoName> --public --source=. --description "<one-line>" --push`
   - **Creating a public repo requires explicit user authorisation** — confirm before running `gh repo create --public`.
7. **Optional index registration.** If `RESOURCE_LIST_PUBLIC_INDEX` is set (e.g. `Resources-Lists-Index`), offer to add a pointer there using its existing format. Do not auto-edit without confirmation.
8. **Report.** Repo URL, entry count, sections used, anything skipped.

## Built-in README template

```markdown
# <Title> [![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

[![View on GitHub](https://img.shields.io/badge/View%20on-GitHub-181717?logo=github&logoColor=white)](https://github.com/danielrosehill/<RepoName>)

<One-paragraph description of the list and its scope.>

## Scope

### In Scope
- ...

### Out Of Scope
- ...

## Discovery sources

<Optional — bullet list of GitHub topic pages, awesome lists, or other origin URLs.>

---

## Contents

- [<Section A>](#section-a)
- [<Section B>](#section-b)

---

## <Section A>

| Project | Description | Stars |
|---|---|---|
| [Project Name](https://github.com/OWNER/REPO) | Description ≤22 words. | ![](https://img.shields.io/github/stars/OWNER/REPO?style=social) |

## <Section B>

| Project | Description | Stars |
|---|---|---|

---

# List Authorship

## List Author

Curated by [Daniel Rosehill](https://danielrosehill.com).

Contributions, corrections, and PRs welcome.

## License

[![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png)](https://creativecommons.org/publicdomain/zero/1.0/)

To the extent possible under law, the author has dedicated all copyright and related and neighboring rights to this list to the public domain worldwide under [CC0](https://creativecommons.org/publicdomain/zero/1.0/). Linked projects retain their own licenses.
```

## Edge cases

- **No entries supplied** — write a scope-only scaffold with empty section tables. Still create the repo.
- **Mixed Git hosts** — only GitHub repos get the star badge. For GitLab/Codeberg/etc., omit the badge cell or render `—`.
- **Org URLs** — list each notable repo separately rather than the org root.
- **Existing repo at the target path** — stop and report; do not overwrite.
