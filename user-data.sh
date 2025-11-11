#!/bin/bash
# Adventure Works Joomla Installation Script

sudo apt update -y
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-xml php-gd php-cli php-zip unzip curl

sudo systemctl enable apache2
sudo systemctl start apache2

cd /var/www/html
sudo curl -L -o joomla.zip https://github.com/joomla/joomla-cms/releases/download/3.9.28/Joomla_3.9.28-Stable-Full_Package.zip
sudo unzip joomla.zip && sudo rm joomla.zip

echo "healthy" | sudo tee /var/www/html/health.txt

sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo find /var/www/html -type f -exec chmod 644 {} \;

sudo systemctl restart apache2

echo "Joomla successfully installed and ready."

