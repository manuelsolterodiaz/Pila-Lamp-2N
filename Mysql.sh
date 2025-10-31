#!/bin/bash
# Aprovisionamiento del servidor MySQL + PHPMyAdmin

set -e
# Variable con la contraseña de phpmyadmin
PHPMYADMIN_APP_PASSWORD="abcd"

# Actualizando paquetes e instalando MariaDB, Apache y PHP
echo " Actualizando paquetes e instalando MariaDB, Apache y PHP..."
apt update
apt install
apt install -y git mariadb-server apache2 php libapache2-mod-php php-mysql
# Insalando PHPMyAdmin
echo " Instalando PHPMyAdmin..."
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl
# Configurando MariaDB
echo " Configurando MariaDB..."
systemctl enable mariadb
systemctl start mariadb
# Creando base de datos y usuario
echo " Creando base de datos y usuario..."
mysql -u root <<FIN
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'manuelsolt'@'%' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'manuelsolt'@'%';
FLUSH PRIVILEGES;
FIN
# Clonando repositorio para importar estructura de la base de datos
echo " Clonando repositorio para importar estructura de la base de datos..."
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Importando estructura desde database.sql en la base de datos gestion_usuarios
echo " Importando estructura desde database.sql en la base de datos gestion_usuarios..."
mysql -u root gestion_usuarios <<EOF
USE gestion_usuarios;
$(cat iaw-practica-lamp/db/database.sql)
EOF
#  Reiniciando Apache
echo " Reiniciando Apache..."
systemctl restart apache2
# Quitar puerta de enlace para que no tenga acceso a internet
ip route del default
echo " Servidor MySQL y PHPMyAdmin aprovisionado correctamente."
