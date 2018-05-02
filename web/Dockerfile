FROM debian:stretch-slim
ARG MAGENTO_USER_ID
ARG MAGENTO_USER_GROUP_ID

# Base package install first so that it's in cache for next actions.
RUN apt update && apt install -y \
	apache2 php7.0 libapache2-mod-php7.0 php-xdebug \
        php7.0-gd \
        php7.0-mysql \
        php7.0-mcrypt \
        php7.0-bcmath \
        php7.0-curl \
        php7.0-mbstring \
        php7.0-xsl \
        php7.0-intl \
        php7.0-soap \
        php7.0-zip \
	mysql-client \
        less vim iputils-ping curl wget \
        && curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/composer

# Other installations
ADD https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
RUN chmod a+x /usr/local/bin/mhsendmail

# Additional packages
# ...

# Default env
ENV M2_ROOT_DIR=/var/www/magento

# Create a user with uid and gid as provided
RUN groupadd --gid $MAGENTO_USER_GROUP_ID magento \
	&& useradd --uid $MAGENTO_USER_ID --gid $MAGENTO_USER_GROUP_ID --create-home magento \
	&& echo "cd $M2_ROOT_DIR" >> /home/magento/.bashrc \
	&& mkdir /home/magento/.composer && chown magento.magento /home/magento/.composer

# Apache stuff
RUN a2enmod rewrite \
	&& echo "export APACHE_RUN_USER=magento" >> /etc/apache2/envvars \
	&& echo "export APACHE_RUN_GROUP=magento" >> /etc/apache2/envvars \
	&& mkdir "$M2_ROOT_DIR" && chown magento.magento "$M2_ROOT_DIR"

# Copy scripts
COPY bin/*.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.sh

CMD [ "/usr/sbin/apache2ctl", "-DFOREGROUND" ]

