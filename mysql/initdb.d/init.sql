CREATE DATABASE magento;

CREATE USER 'magento'@'%' IDENTIFIED BY 'magento';
GRANT ALL ON magento.* TO 'magento'@'%';

