# Vanilla PHP + JavaScript — WSC2026 minimal app

```bash
docker compose up --build
```

- **http://localhost** — the vanilla PHP page (`index.php`, server-rendered)
- **http://localhost/index.html** — the vanilla JavaScript page (`scripts.js` + fetch)

JSON API: `GET api/tasks.php`, `POST api/tasks.php` (`{ "title": "..." }`).

Apache serves both pages plus the JS and CSS from one document root. `DirectoryIndex` is
set to `index.php index.html` so `/` lands on the PHP page; each page links to the other.

Tasks live in a self-contained **SQLite** file at `/var/www/data/app.db` — no database
server, and deliberately outside the document root so it cannot be fetched over HTTP.
The entrypoint creates and seeds the schema before Apache starts. Override with `DB_PATH`.

Using MySQL or MariaDB instead? Swap the DSN in `config/db.php` — `pdo_mysql` and
`mysqli` are compiled into the image alongside `pdo_sqlite`, so nothing needs rebuilding.

Pinned: PHP 8.3 (Apache). No package manager, no build step, no dependencies.
