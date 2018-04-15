# ca-m2-std

A composer stack for Magento 2.

Useful to test behaviours and changes on a standard Magento.


## Quick start

1. Enter `make run` : it will run containers in this terminal. The first time, an interactive configuration script will ask a few questions, then containers will be built.
1. In another terminal, enter `make install` : it will setup Magento files and install Magento

You will need an access key (http://devdocs.magento.com/guides/v2.2/install-gde/prereq/connect-auth.html) since Magento setup is done through composer install.

Backend url is: **(base url)admin** ; backend user is: **admin** / **admin123**

