# Vanilla — WSC2026

A starting point for competitors who want to build **without a framework**, in plain PHP,
plain JavaScript, or both (WorldSkills 2026 Web Technologies, TP17).

Two entry points, one small task-list app, so you can see each stack working before you
delete the demo and write your own:

- **`index.php`** — rendered on the server. No JavaScript involved.
- **`index.html` + `scripts.js`** — rendered in the browser, fetching `api/tasks.php`.

Both read the same SQLite database through **`config/db.php`**.

## Run it

```bash
docker compose up --build
```

- **http://localhost** → the PHP page
- **http://localhost/index.html** → the JavaScript page

Stop with `docker compose down`.

## How to use it

1. Building with plain PHP? Start from **`index.php`**.
2. Building with plain JavaScript? Start from **`index.html`** and **`scripts.js`**.
3. Either way, put database configuration in **`config/db.php`**.

Delete whichever half you don't need. There is no build step, no package manager, and no
dependencies — edit a file, reload the page.

## Files

| File | What it is |
|------|------------|
| `index.php` | Vanilla PHP entry point — server-rendered page |
| `index.html` | Vanilla JavaScript entry point — static markup |
| `scripts.js` | Fetches and renders the task list, handles the add form |
| `api/tasks.php` | JSON API: `GET` lists tasks, `POST` adds one |
| `config/db.php` | PDO connection + schema/seed helpers |
| `styles.css` | Shared styling for both pages |

## Database

A self-contained **SQLite** file — there is no database server to run or configure. The
schema is created and seeded on container start by `docker-entrypoint.sh`.

The file lives at `/var/www/data/app.db`, **outside the document root**, so it cannot be
downloaded over HTTP. Override the location with the `DB_PATH` environment variable.

To use MySQL or MariaDB instead, swap the DSN in `config/db.php` (the alternative is
written in a comment there) and point it at your server. The `pdo_mysql` and `mysqli`
extensions are already compiled into the image, so no `Dockerfile` change is needed.

## Stack

- PHP 8.3 (Apache, `pdo_sqlite` + `pdo_mysql`/`mysqli`)
- No framework, no build step, no dependencies
