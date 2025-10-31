
#!/bin/bash
# Aprovisionamiento del servidor Apache

set -e
# Actualizando paquetes e instalando Apache y PHP
echo " Actualizando paquetes e instalando Apache y PHP..."
sudo apt update
sudo apt install apache2 php -y
# Clonando aplicación desde GitHub
echo " Clonando aplicación desde GitHub..."
sudo apt install -y git
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
sudo  mv iaw-practica-lamp/src/* /var/www/html/
chown -R www-data:www-data /var/www/html/
sudo  systemctl restart apache2
# Configurando conexión a la base de datos
echo " Configurando conexión a la base de datos..."
cat <<EOF > /var/www/html/config.php
<?php
define('DB_HOST', '192.168.33.11');
define('DB_NAME', 'gestion_usuarios');
define('DB_USER', 'manuelsolt');
define('DB_PASSWORD', 'abcd');

\$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
?>
EOF
# Reiniciando Apache
echo " Reiniciando Apache..."
sudo systemctl restart apache2

echo " Servidor Apache aprovisionado y funcionando correctamente."
