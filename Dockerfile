# Build container with dependencies for building Spryker and running tests
# It contains PHP, XDebug, Composer, NodeJS and Yarn

FROM korekontrol/spryker-php:php7.1

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm -f composer-setup.php \
  && composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --optimize-autoloader --classmap-authoritative \
	&& composer clear-cache \
  && wget -qO - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
	&& echo "deb https://deb.nodesource.com/node_8.x stretch main" > /etc/apt/sources.list.d/nodesource.list \
  && wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get -y --no-install-recommends install \
       php-xdebug nodejs yarn \
  && rm -rf /var/lib/apt/lists/*
