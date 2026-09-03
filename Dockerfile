# PHP pinned to the WSC2026 spec. Apache serves index.php, index.html, JS and CSS
# from one document root — no extra web server config needed.
FROM php:8.3-apache

RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev \
    && docker-php-ext-install -j"$(nproc)" pdo_sqlite \
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
