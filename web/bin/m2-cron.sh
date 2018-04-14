#!/bin/sh

# See http://devdocs.magento.com/guides/v2.2/install-gde/install/post-install-config.html

echo "Executing cron:run command ..."
php "$M2_ROOT_DIR/bin/magento" cron:run

echo "Executing update/cron.php ..."
php "$M2_ROOT_DIR/update/cron.php"

echo "Executing setup:cron:run command ..."
php "$M2_ROOT_DIR/bin/magento" setup:cron:run

