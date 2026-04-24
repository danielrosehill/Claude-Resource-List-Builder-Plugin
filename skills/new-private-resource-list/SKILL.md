---
name: new-private-resource-list
description: Use when the user wants to scaffold a new PRIVATE GitHub resource list — same shape as the public skill but the repo is created private and registered in a private index. Triggers — "new private resource list", "create a private list of...", "internal-only list of repos for X". For public lists use `new-resource-list`.
---

# New Resource List (Private)

Scaffold a new private GitHub resource list. Identical shape to `new-resource-list` but with private-repo defaults and a different index target.

## What differs from the public flow

- Repo is created with `gh repo create ... --private` (no Awesome badge convention required, but kept for consistency).
- Default base path: `~/repos/github/my-repos/` unless `RESOURCE_LIST_PRIVATE_BASE` is set.
- License footer: omit CC0; substitute "All rights reserved." or honour `RESOURCE_LIST_PRIVATE_LICENSE` if set.
- Index target: honour `RESOURCE_LIST_PRIVATE_INDEX` (defaults to none — ask the user).
- Display name on the README still says "Curated by Daniel Rosehill" but **no public-website link** by default.

## Procedure

Identical to `new-resource-list` (alphabetical sections, alphabetical rows, project/description/stars table, gh metadata fetch) — refer to that skill for shape details. The only deltas are the four bullets above.

When in doubt about whether the user wants public or private, **ask once** before creating. A wrong public/private choice is hard to fully reverse.

## Edge cases

- **User accidentally invokes the public skill for sensitive content** — if you spot signs (client names, internal infra, embargoed research) before pushing, stop and confirm.
- **Private + Awesome badge** — keep it (it's just an SVG); some users like the visual continuity. Drop only if asked.
