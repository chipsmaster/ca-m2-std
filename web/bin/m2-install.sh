#!/bin/sh

set -e

echo "Installing magento..."

cd "$M2_ROOT_DIR"


base_url="${M2_PUB_URL}"
if [ -z "$base_url" ]
then
	echo "No base url"
	exit 1
fi

use_secure=0
use_secure_admin=0
base_url_secure_opt=""
backend_frontend_name=admin

proto="${base_url%%://*}"
if [ "$proto" = https ]
then
	use_secure=1
	use_secure_admin=1
	base_url_secure_opt="--base-url-secure=$base_url"
fi

admin_password="admin123"
language=fr_FR
currency=EUR
timezone=Europe/Paris


bin/magento setup:install \
	--db-host="${M2_DB_HOST}" \
	--db-name="${M2_DB_NAME}" \
	--db-user="${M2_DB_USER}" \
	--db-password="${M2_DB_PASS}" \
	--admin-firstname=Magento \
	--admin-lastname=Admin \
	--admin-email=admin@example.com \
	--admin-user=admin \
	--admin-password="${admin_password}" \
	--base-url="$base_url" \
	--backend-frontname="$backend_frontend_name" \
	--use-secure="$use_secure" \
	--use-secure-admin="$use_secure_admin" \
	$base_url_secure_opt \
	--use-rewrites=1 \
	--language="$language" \
	--currency="$currency" \
	--timezone="$timezone" \
	--no-interaction \
	--cleanup-database


