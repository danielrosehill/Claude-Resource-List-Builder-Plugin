# Entry handling (shared by all skills)

## Resolve the profile first
```bash
P=$("${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh" profile)   # overlay profile.yaml, else built-in defaults
"${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh"                # data dir + rule
```
Read it; keys missing from the overlay fall back to `${CLAUDE_PLUGIN_ROOT}/defaults/profile.yaml`.
Templates: `paths.sh template <name>` (overlay copy wins).

## Classify each URL
| URL | Source | Id |
|---|---|---|
| github.com/OWNER/REPO | github | OWNER/REPO |
| huggingface.co/ID | hf model | ID |
| huggingface.co/datasets/ID | hf dataset | ID |
| huggingface.co/spaces/ID | hf space | ID |
| anything else (site, paper) | web | none, no badge |

## Metadata
- GitHub: `gh repo view OWNER/REPO --json description,stargazerCount,pushedAt,isArchived,topics`
- Hugging Face (no auth needed): `curl -s https://huggingface.co/api/models/<id>` (also `/api/datasets/<id>`, `/api/spaces/<id>`).
  Use `cardData`/description for the text (else first line of the README card), `downloads` (not on Spaces), `likes`, `lastModified`, `pipeline_tag` (task), `tags`.
  A 404 body or non-JSON means missing/gated: report it.
- Description: one sentence, at most 22 words, plain tone, ends with a period.

## Entry formats
Format comes from the request, else `formats.third_party` / `formats.own_repos` in the profile (own = repos owned by `github_owner` or the author). Never mix formats inside one list. Templates: `entry-table-*.md`, `entry-cards-*.md`.
- `table`: GitHub `| Project | Description | Stars | Last Updated |`; HF `| Model/Dataset/Space | Description | Downloads | Likes |`. Mixed sources: separate tables per section (or sub-tables), never mixed columns. Drop the Stars/Downloads/Likes columns if `show_stars: false`, the Last Updated column if `show_last_updated: false`. Web entries: `| [Name](url) | Description |` rows in their own table or `-` cells.
- `cards`: `### Name`, one-paragraph description, then a badge line: GitHub `[![View Repo](https://img.shields.io/badge/View-Repo-blue?style=flat&logo=github)](url)`, HF a Hugging Face badge. Add stat badges only if `show_stars` / `show_last_updated` are true. Web entries: description plus a plain link badge, no stats. Cards are separated by a blank line (a `---` rule if the existing list uses one: follow the list).

HF stat badges are shields.io dynamic JSON. URL-encode the API url; `/` in the id becomes `%2F`:
`https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fhuggingface.co%2Fapi%2Fmodels%2F<id>&query=%24.downloads&label=downloads&logo=huggingface` (`%24.likes` for likes; `datasets`/`spaces` for the API segment).

## Ordering and sections
Sections alphabetical; entries alphabetical by display name within a section. If `section_descriptions` is true, every section has a one or two sentence description under its heading (write one for any new section; add missing ones when touching a list). Display name is human-readable, not the raw slug.

## Detecting an existing list's format
Table header present -> table; `### ` entry headings with badge lines -> cards. Follow the existing list; offer conversion only if asked.
