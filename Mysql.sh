#!/bin/bash

# Comandos para actualizar repositorios e instalar MariaDB como SGBD
sudo apt update
sudo apt install -y mariadb-server

# Habilitar y arrancar el servicio
sudo systemctl enable mariadb
sudo systemctl start mariadb
# Crear base de datos y creación de usuario manuel y tiene todos los privilegios
mysql -u root <<FIN
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'manuelsolt'@'%' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'manuelsolt'@'%';
FLUSH PRIVILEGES;
FIN