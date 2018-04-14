#!/bin/sh

set -e

setup_if_needed="$1"

cd "$M2_ROOT_DIR"

if [ -n "$(ls -A)" ]
then
	if [ -n "$setup_if_needed" ]
	then
		exit 0
	else
		echo "Magento root dir is not empty, clear it first"
		exit 1
	fi
fi

composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

chmod u+x bin/magento

