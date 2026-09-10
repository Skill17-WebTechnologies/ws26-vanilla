# PHP pinned to the WSC2026 spec. Apache serves index.php, index.html, JS and CSS
# from one document root — no extra web server config needed.
FROM php:8.3-apache

# Both database stacks are compiled in, so a competitor can point config/db.php at
# either one without rebuilding: pdo_sqlite for the self-contained file that ships with
# this template, pdo_mysql/mysqli for a MySQL or MariaDB server. The MySQL extensions
# use the bundled mysqlnd driver, so they need no extra system packages.
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev \
    && docker-php-ext-install -j"$(nproc)" pdo_sqlite pdo_mysql mysqli \
    && rm -rf /var/lib/apt/lists/*

# Serve index.php first; index.html stays reachable at /index.html.
RUN printf 'DirectoryIndex index.php index.html\n' > /etc/apache2/conf-available/directory-index.conf \
    && a2enconf directory-index

COPY . /var/www/html
RUN rm -f /var/www/html/Dockerfile /var/www/html/docker-compose.yml /var/www/html/docker-entrypoint.sh

# The SQLite file lives outside the document root so it cannot be fetched over HTTP.
RUN mkdir -p /var/www/data && chown -R www-data:www-data /var/www/data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/entrypoint
# Strip any CR before making the entrypoint executable. .gitattributes already
# forces LF on checkout, but that only helps a fresh clone — this keeps a working
# copy that was checked out before it, or copied off a Windows share, from
# producing "env: 'bash\r': No such file or directory" and exit 127.
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint \
    && chmod +x /usr/local/bin/entrypoint

ENV DB_PATH=/var/www/data/app.db

EXPOSE 80
ENTRYPOINT ["entrypoint"]
