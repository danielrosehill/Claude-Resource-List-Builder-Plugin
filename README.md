# Resource List Builder

A Claude Code plugin to build, maintain and audit curated resource lists (Awesome-style indexes) of GitHub repos, Hugging Face models, datasets and Spaces, and web links. Drop a flat list of URLs into a chat; the agent fetches metadata, sorts entries into alphabetical sections and writes them in a consistent format.

## Skills

| Skill | Purpose |
|---|---|
| `setup` | Create or update your overlay `profile.yaml`; shows the resolved data dir. |
| `new-resource-list` | Scaffold a new list repo (public or private) with README, optional SCOPE.md, optional hub / index-of-indexes registration. |
| `update-resource-list` | Add entries: classify, fetch metadata, dedupe, categorise, alphabetise, commit, push. |
| `reorganise-resource-list` | Rename, merge, split sections; move entries; convert format. |
| `analyze-resource-list` | Audit for dead, archived, stale, low-traction entries (GitHub and HF); optional prune. |
| `release-resource-list` | Dated CSV snapshot plus GitHub Release. |
| `export-resource-list-pdf` | Render a list to PDF. |

## Overlay: your settings live outside the plugin

Defaults are neutral. Your own conventions go in a private data directory, resolved in this order:
`$RESOURCE_LIST_BUILDER_DATA`, `$CLAUDE_USER_DATA/resource-list-builder`, `~/.claude-user-data/resource-list-builder` (if `~/.claude-user-data` exists), `${XDG_DATA_HOME:-~/.local/share}/claude-plugins/resource-list-builder`.
Run `scripts/paths.sh` to see which one is in use. Files there override built-ins by name:

- `profile.yaml`: settings (see `defaults/profile.yaml`, which documents every key).
- `templates/`: same file names as the plugin's `templates/` (`README.md`, `SCOPE.md`, `section.md`, `entry-*.md`) replace the built-ins.

Run the `setup` skill to create the profile.

## Profile keys

| Key | Meaning |
|---|---|
| `author.name`, `author.url` | Shown in the Contributing block. |
| `contribution_line` | Text under Contributing. |
| `license.id`, `license.badge` | Licence and badge markdown. |
| `default_visibility` | `public` or `private` for new repos. |
| `private_footer` | Keep the contribution/licence footer on private lists. |
| `base_dir`, `private_base_dir` | Where new list repos are cloned. |
| `github_owner` | Owner for `gh repo create`. |
| `top_badge` | Optional badge line above the title. |
| `scope_file` | Create SCOPE.md and link it. |
| `section_descriptions` | One or two sentences under each section heading. |
| `show_stars`, `show_last_updated` | Stat columns (table) or badges (cards). |
| `formats.third_party`, `formats.own_repos` | `table` or `cards`. |
| `index_of_indexes` | Optional repo listing all your indexes: new lists are registered there and link back. |
| `hubs` | Optional parent hubs (name, local path, repo, section, row format) a new list can join. |
| `naming` | Repo naming convention. |

## Formats

`table` (GitHub; drop the stat columns with `show_stars` / `show_last_updated` false):

```markdown
| Project | Description | Stars | Last Updated |
|---|---|---|---|
| [Name](https://github.com/OWNER/REPO) | One sentence. | ![](https://img.shields.io/github/stars/OWNER/REPO?style=social) | ![](https://img.shields.io/github/last-commit/OWNER/REPO) |
```

`cards`:

```markdown
### Name

One-paragraph description.

[![View Repo](https://img.shields.io/badge/View-Repo-blue?style=flat&logo=github)](https://github.com/OWNER/REPO)
```

## Hugging Face support

Models, datasets and Spaces (`huggingface.co/<id>`, `/datasets/<id>`, `/spaces/<id>`) are read from the public API (`curl -s https://huggingface.co/api/models/<id>`): description, downloads, likes, `lastModified`, task. Table columns are `| Model | Description | Downloads | Likes |` using shields.io dynamic-JSON badges, e.g.

```
https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fhuggingface.co%2Fapi%2Fmodels%2F<id>&query=%24.downloads&label=downloads&logo=huggingface
```

Mixed sources use separate tables per section. Websites and papers get no badge.

## License

MIT. Created by Daniel Rosehill.
