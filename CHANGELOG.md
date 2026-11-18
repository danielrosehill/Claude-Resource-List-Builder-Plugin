# Changelog

## 0.2.0
- Generic for any user: personal conventions moved to a private overlay (`profile.yaml` + optional `templates/`), resolved by `scripts/paths.sh`. Built-in `defaults/profile.yaml` documents every key.
- New `setup` skill creates/updates the overlay profile.
- Two entry formats: `table` and `cards`; `show_stars` / `show_last_updated` options; section descriptions option.
- Hugging Face models, datasets and Spaces supported in every skill (metadata via the public HF API, shields.io dynamic-JSON badges).
- `SCOPE.md` generated for new lists (profile `scope_file`).
- Parent hub and index-of-indexes registration with back-links and sibling cross-links.
- `new-private-resource-list` merged into `new-resource-list` (visibility from request or profile); no confirmation step for public repos.
- `release-resource-list` CSV gains `source`, `kind`, `downloads`, `likes`, `task`; `analyze-resource-list` handles HF staleness and 404s.
- Removed env variables (`RESOURCE_LIST_PUBLIC_BASE` etc.); use the profile.

## 0.1.0
- Initial release.
