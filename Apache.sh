# sscript para instalar apache desde GitHub
#!/bin/bash
apt update
apt install -y apache2 php

wget -O app.zip https://informatica.iesalbarregas.com/mod/url/view.php?id=4382
unzip appgithub.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/
sudo service apache2 restart