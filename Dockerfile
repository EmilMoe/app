FROM cloudmonitor/laravel

RUN git clone --progress https://x-access-token:${CI_DEPLOY_PASSWORD}@gitlab.com/${CI_PROJECT_DIR} -b ${CI_COMMIT_BRANCH} .
RUN chmod 777 -R /var/www/html/bootstrap/cache /var/www/html/storage

# Composer
RUN mkdir -p /tmp/composer && cp /var/www/html/composer.* /tmp/composer/
WORKDIR /tmp/composer
RUN composer install --no-dev --no-autoloader --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist --verbose
RUN cp -r /tmp/composer/vendor /var/www/html/vendor
WORKDIR /var/www/html
RUN composer dump-autoload --optimize

# Npm
RUN mkdir -p /tmp/npm && cp /var/www/html/package* /tmp/npm
WORKDIR /tmp/npm
RUN npm install
RUN cp -r /tmp/npm/node_modules /var/www/html/node_modules
WORKDIR /var/www/html
RUN npm run prod

# After
COPY run_script /usr/local/bin/run_script
RUN chmod a+rx /usr/local/bin/run_script
