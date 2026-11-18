---
name: setup
description: Create or update the user's resource-list-builder profile (author, licence, visibility, base directory, entry formats, hubs, index of indexes) in the private overlay. Use on "set up resource list builder", "change my list defaults", "where does the plugin read settings", or when other skills report the profile missing.
---

# Setup

Creates or edits `profile.yaml` in the overlay data directory. Read `${CLAUDE_PLUGIN_ROOT}/reference/entries.md` for conventions.

1. Run `"${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh"` and show the data dir and rule. Overlay is never inside the plugin.
2. If `<data dir>/profile.yaml` exists, read it; otherwise start from `${CLAUDE_PLUGIN_ROOT}/defaults/profile.yaml` (documents every key).
3. Fill keys from flags or the user's message; ask only for what is missing, in one batch, with defaults shown: author name and url, github owner, contribution line, licence (id + badge), default visibility, base dir (and private base dir), top badge, scope_file, section_descriptions, show_stars, show_last_updated, formats (third_party / own_repos), index_of_indexes, hubs (name, local path, repo, section, row format), repo naming convention.
4. Write `<data dir>/profile.yaml` (create the dir). Keep comments. Templates the user wants to customise are copied by name into `<data dir>/templates/` only on request; built-ins are never copied otherwise.
5. If the data dir is inside a git repo (e.g. `~/.claude-user-data`), stage only this plugin's folder: `git -C <root> add resource-list-builder`. Commit and push only when the user asks or the repo is theirs and private.
6. Print the resolved data dir and the final profile.
