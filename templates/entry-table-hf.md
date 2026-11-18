Header (use "Model", "Dataset" or "Space"; drop Downloads/Likes when show_stars is false; Spaces have no downloads, use Likes only):

| Model | Description | Downloads | Likes |
|---|---|---|---|

Row (path = `<id>` for models, `datasets/<id>`, `spaces/<id>`; API = `models|datasets|spaces`):

| [{{NAME}}](https://huggingface.co/{{PATH}}) | {{DESCRIPTION}} | ![](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fhuggingface.co%2Fapi%2F{{API}}%2F{{ID_URLENCODED}}&query=%24.downloads&label=downloads&logo=huggingface) | ![](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fhuggingface.co%2Fapi%2F{{API}}%2F{{ID_URLENCODED}}&query=%24.likes&label=likes&logo=huggingface) |
