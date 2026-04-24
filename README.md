# Resource List Builder — Claude Code Plugin

Build, maintain, and audit curated GitHub resource lists (Awesome-style indexes) without reinventing the format every time.

The value-add is **AI-driven categorisation**: drop a flat list of repo URLs into a chat, the agent fetches metadata, sifts entries into sensible sections, and writes them out in a consistent, alphabetised table format with dynamic star badges.

## Skills

| Skill | Purpose |
|---|---|
| `new-resource-list` | Scaffold a new **public** GitHub resource list with the standard shape. |
| `new-private-resource-list` | Same, but the repo is created private with a private-friendly footer. |
| `update-resource-list` | Add new entries to an existing list — agent categorises, dedupes, alphabetises, commits. |
| `reorganise-resource-list` | Re-bucket / rename / split / merge sections in an existing list. |
| `analyze-resource-list` | Audit a list — flag dead, stale, low-star, drifted-description entries; optional pruning. |
| `export-resource-list-pdf` | Render a list to PDF (via Typst / pandoc) for sharing or archiving. |

## Standard list shape

Every list created by this plugin defaults to:

- Awesome badge + scope block (In Scope / Out Of Scope) at top
- Optional Discovery sources block
- **Sections in alphabetical order**
- **Rows in alphabetical order within each section** (by display name)
- Three-column tables: `| Project | Description | Stars |`
- Dynamic shields.io star badges per row
- Descriptions ≤22 words, drawn from `gh repo view ... --json description` and trimmed
- CC0 footer for public lists; "All rights reserved." for private (override via env)

## Environment variables

| Variable | Purpose | Default |
|---|---|---|
| `RESOURCE_LIST_PUBLIC_BASE` | Local base path for new public list repos | `~/repos/github/my-repos/` |
| `RESOURCE_LIST_PRIVATE_BASE` | Local base path for new private list repos | `~/repos/github/my-repos/` |
| `RESOURCE_LIST_TEMPLATE_PATH` | Override README template (still subject to alphabetisation) | built-in |
| `RESOURCE_LIST_PUBLIC_INDEX` | Index repo to optionally register new public lists into | unset |
| `RESOURCE_LIST_PRIVATE_INDEX` | Index repo to optionally register new private lists into | unset |
| `RESOURCE_LIST_PRIVATE_LICENSE` | License footer for private lists | `All rights reserved.` |

## License

MIT.
