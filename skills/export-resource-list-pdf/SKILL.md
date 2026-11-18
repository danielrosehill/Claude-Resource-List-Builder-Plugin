---
name: export-resource-list-pdf
description: Render a resource list README to PDF for sharing or archiving, with badges stripped. Triggers: "export the <topic> list as PDF", "printable version of this list".
---

# Export Resource List to PDF

1. Resolve the profile (`"${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh" profile`) for the base dir and any export preferences; the source is the README of the named list.
2. Make a temp copy of the markdown with shields.io badge images removed (they paginate badly and live counts are stale in print). For cards, keep the heading, description and a plain link in place of the badge line; for tables, drop the badge cells or columns but keep the linked name.
3. Render: use a Typst-capable skill if one is available (a template from the overlay `templates/` wins), else `pandoc in.md -o out.pdf --pdf-engine=typst`, fallback `--pdf-engine=tectonic`. Use 2 columns above ~200 entries.
4. Footer: "Snapshot taken YYYY-MM-DD; project status may have changed since."
5. Write to `outputs/<list>-<YYYY-MM-DD>.pdf` in the list repo (or the given path). Do not commit unless asked. Report path and page count.
