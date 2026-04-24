---
name: export-resource-list-pdf
description: Use when the user wants to render an existing resource list to a PDF for sharing/archiving. Triggers — "export the <topic> list as PDF", "PDF of this resource list", "make a printable version of the eval list".
---

# Export Resource List to PDF

Render the README of a resource list into a PDF using Typst (Daniel's preferred tooling).

## Procedure

1. **Resolve the source.** Default to the README of the list repo passed by the user.
2. **Strip dynamic shields.io badges** from the markdown copy used for rendering — they don't paginate well in print and the star counts are stale by the time the PDF is opened. Keep the bracketed link to the repo.
3. **Convert to Typst input** via the workspace's standard pipeline:
   - If the `typst` skill is available, hand off to it with a `resource-list` template.
   - Otherwise, render via `pandoc <input>.md -o <output>.pdf --pdf-engine=typst` (preferred) or `--pdf-engine=tectonic` as fallback.
4. **Write the PDF** to `outputs/<list-name>-<YYYY-MM-DD>.pdf` inside the list repo (create `outputs/` if missing). Or honour an explicit path from the user.
5. **Optionally upload** to Google Drive via the `save-to-gdrive` skill if the user asks.
6. **Report** the output path and page count.

## Notes

- This is an export, not a snapshot of live data. Mention in the PDF footer: "Snapshot taken YYYY-MM-DD — star counts and project status may have changed since."
- For very long lists (>200 entries), enable a 2-column layout in the Typst template to keep page count reasonable.
- Don't commit the PDF unless the user asks — these are typically ephemeral.
