---
name: analyze-resource-list
description: Audit a resource list for dead, archived, stale, low-traction or description-drifted entries across GitHub repos and Hugging Face models/datasets/Spaces, then optionally prune. Triggers: "audit the <topic> list", "find stale entries", "what should I cut".
---

# Analyze Resource List

Read `${CLAUDE_PLUGIN_ROOT}/reference/entries.md` first. Read-only unless the user approves a prune.

Thresholds (override per request): low traction < 50 stars (GitHub) or < 100 downloads and < 5 likes (HF); stale > 18 months.

1. Extract every link from the README (both formats) and classify it.
2. Fetch in parallel:
   - GitHub: `gh repo view OWNER/REPO --json stargazerCount,pushedAt,isArchived,isFork,description`; 404 = dead.
   - HF: `curl -s -w '\n%{http_code}' https://huggingface.co/api/<models|datasets|spaces>/<id>`; HTTP 404 (or body with an `error` key) = dead; use `lastModified` for staleness, `downloads`/`likes` for traction, `disabled`/`private` flags as gated.
   - Web links: `curl -sIL -o /dev/null -w '%{http_code}'`; 4xx/5xx = suspect (some sites block bots, say so).
3. Bucket: dead, stale, low-traction, forks, description-drift, healthy. Do not apply the low-traction bucket when the list's profile has `show_stars: false` unless the user asks; staleness and dead checks always run.
4. Report a table worst-first (section, entry, source, traction, last activity, flags). Write it to `outputs/<list>-audit-<date>.md` only if asked.
5. Offer a prune plan; mutate only on explicit approval (drop rows/cards, update TOC, commit `Audit prune: <n>`, push).

Never auto-remove; a niche low-star entry may be wanted. Rate limits: go sequential or use `gh api graphql`. Moved repos: surface the new location.
