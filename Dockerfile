FROM ubuntu:14.10

RUN apt-get update && apt-get upgrade -y
# set environment
#RUN MYSQL_ROOT_PASSWORD=`date +%s | sha256sum | base64 | head -c 32`

# persistent / runtime deps
RUN apt-get install --no-install-recommends -y ca-certificates unzip python-software-properties mc curl libpcre3 librecode0 libsqlite3-0 libxml2 mysql-client \ 
# nginx + php
 php5-fpm php5-cli php5-dev php5-common \ 
 php5-mysql php5-curl php5-gd php5-mcrypt php5-sqlite php5-xmlrpc \ 
 php5-xsl php5-intl php-apc php5-sqlite \ 
# programs
 mc nano git htop wget lynx links mcrypt curl procps mysql-client

RUN php5enmod mcrypt

# Setup php5 cli options
RUN sed -i -e "s/;date.timezone\s=/date.timezone = UTC/g" /etc/php5/cli/php.ini
RUN sed -i -e "s/short_open_tag\s=\s*.*/short_open_tag = Off/g" /etc/php5/cli/php.ini
RUN sed -i -e "s/memory_limit\s=\s.*/memory_limit = 2048M/g" /etc/php5/cli/php.ini
RUN sed -i -e "s/max_execution_time\s=\s.*/max_execution_time = 0/g" /etc/php5/cli/php.ini

# Setup php5 fpm options
RUN sed -i -e "s/;date.timezone\s=/date.timezone = UTC/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/short_open_tag\s=\s*.*/short_open_tag = Off/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/memory_limit\s=\s.*/memory_limit = 1024M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/max_execution_time\s=\s.*/max_execution_time = 0/g" /etc/php5/fpm/php.ini

# install composer
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer.phar
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Add nginx repo and install nginx
RUN curl http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN echo "deb http://nginx.org/packages/mainline/ubuntu/ `lsb_release -cs` nginx\ndeb-src http://nginx.org/packages/mainline/ubuntu/ `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list
RUN apt-get -y install nginx

# install node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

# cleanup
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,cache,log}/

WORKDIR /var/www

COPY etc /etc


COPY entrypoint.sh /entrypoint.sh

VOLUME ["/var/www"]
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
