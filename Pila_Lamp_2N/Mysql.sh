#!/bin/bash
# Aprovisionamiento del servidor MySQL + PHPMyAdmin

set -e

PHPMYADMIN_APP_PASSWORD="abcd"

echo "🔧 Actualizando paquetes e instalando MariaDB y PHP..."
apt update
apt install -y mariadb-server apache2 php libapache2-mod-php php-mysql

echo "📦 Instalando PHPMyAdmin..."
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl

echo "🛠️ Configurando MariaDB..."
systemctl enable mariadb
systemctl start mariadb

mysql -u root <<FIN
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'manuelsolt'@'%' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'manuelsolt'@'%';
FLUSH PRIVILEGES;
FIN

echo "🚀 Reiniciando Apache..."
systemctl restart apache2

echo "✅ Servidor MySQL y PHPMyAdmin aprovisionado correctamente."
