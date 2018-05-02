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

project=magento/project-community-edition
if [ "$M2_EE" = y ]
then
	project=magento/project-enterprise-edition
fi

composer create-project --repository-url=https://repo.magento.com/ $project .

chmod u+x bin/magento

