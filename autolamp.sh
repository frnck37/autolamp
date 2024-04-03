#!/bin/bash

# Update package lists
sudo apt update

# Install LAMP server
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip php-xmlrpc php-soap -y

sudo apt install phpmyadmin

sudo phpenmod mysqli

sudo mkdir -p /var/www/cyclo.box/
sudo chown -R franck/var/www/cyclo.box/
sudo mkdir -p /var/www/local.box/
sudo chown -R franck/var/www/local.box/

sudo chmod -R 755 /var/www/

# Configure Apache for virtual host cyclo.box
sudo bash -c 'cat > /etc/apache2/sites-available/cyclo.box.conf << EOF
<VirtualHost *:80>
    ServerAdmin dfranck@mailoo.org
    ServerName cyclo.box
    DocumentRoot /var/www/cyclo.box/public_html

    <Directory /var/www/cyclo.box>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'
# Configure Apache for virtual host local.box
sudo bash -c 'cat > /etc/apache2/sites-available/local.box.conf << EOF
<VirtualHost *:80>
    ServerAdmin dfranck@mailoo.org
    ServerName local.box
    DocumentRoot /var/www/local.box/public_html

    <Directory /var/www/local.box>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Enable the virtual host
sudo a2ensite cyclo.box.conf
sudo a2ensite local.box.conf
sudo a2dissite 000-default.conf

# Restart Apache
sudo systemctl restart apache2

sudo rm /var/www/html/index.html
sudo echo "<?php phpinfo();?>"> /var/www/html/index.php

sudo chmod a+rw -R /var/www/

sudo /etc/init.d/apache2 restart

sudo ln -s /usr/share/phpmydmin /var/www/html/phpmyadmin

sudo /etc/init.d/apache2 restart

sudo systemctl restart apache2

sudo a2enmod rewrite

sudo apache2ctl configtest

sudo apt-get install isc-dhcp-server -y

sudo bash -c 'cat > /etc/apache2/sites-available/local.box.conf << EOF
"INTERFACESv4="wlan0"
"INTERFACESv6=""
EOF'

sudo bash -c 'cat > /etc/apache2/sites-available/local.box.conf << EOF
 net.ipv4.ip_forward=1
EOF'


# Install packages for access point
sudo apt install hostapd dnsmasq -y

# Configure access point
sudo bash -c 'cat > /etc/hostapd/hostapd.conf << EOF
interface=wlan0
driver=nl80211
ssid=cyclo
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOF'

# Configure DHCP server
sudo bash -c 'cat > /etc/dnsmasq.conf << EOF
interface=wlan0
dhcp-range=192.168.1.19,192.168.1.39,255.255.255.0,24h
EOF'

# Start services
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq

#Installation de NogSplash Portail Captif
sudo apt-get install libmicrohttpd-dev

sudo git clone https://github.com/nodogsplash/nodogsplash.git
cd nodogsplash
sudo make
sudo make install

sudo bash -c 'cat > /etc/nodogsplash/nodogsplash.conf
<< EOF
GatewayInterface wlan0
GatewayAddress 192.168.1.19
EOF'


sudo cp ~/nodogsplash/debian/nodogsplash.service /lib/systemd/system/
sudo systemctl enable nodogsplash.service 



#installation automatique sécurisée de Mysql
sudo /usr/bin/mysql_secure_installation 
   
    


# Finish
echo "LAMP server OK."
#Configurer la connexion Internet de votre PI sur"bluetooth".Le plus simple est de partager la connexion de votre téléphone. Vous ne pourrez plus utiliser l'interface wifi ()wlan0) une fois l'installation terminée, et votre pi doit être connectée, même à trés petit débit, pour que le portail captif fonctionne.
# changer les noms d'hotes à votre convenance, ligne 13 à 16
# adapter les paramètres de serveurs virtuels, lignes 20 à 57. Executez la commande "ifconfig" dans le terminal pour afficher l'état de vos interfaces et leurs adresses IP. 
# Changez le SSID de votre point d'accés à votre convenance,  lign 100
# Indiquez l'IP de votre interface wlan0 dans la configuration de dnmasq, ligne 110
# Faites de même dans la configuration du portail captif "GateWayAddress=192.168.X.X" ligne 130
# Exécutez "sudo ./autolamp2.sh" dans votre terminal. L'installation commence.

# L'installation sécurisée de Mysql démarre automatiquement à la fin du script. Répondez aux questions comme suit :
 #Changer le mot de passe root ? y, puis "0"
    #Supprimer l'utilisateur anonyme ? Oui
    #Interdire la connexion root à distance ? Oui
    #Supprimer la base de données de test et y accéder ? Oui
    #Recharger les tables de privilèges maintenant ? Oui

#Mysql est installé et configuré, sans mot de passe pour root. Connectez vous pour vérifier et effectuez les opérations que vous voulez. (Voir documentation Mysql)
# Exécutez "sudo mysql -u root -p" pour vous connecter en root au serveur mysql, sans password.
#Une fois rebooté, votre Pi devrait démarrer en mode point d'accés, et donc non connecté à Internet, en mode "Stand-Alone Access Point". Pour arréter le point d'accés et reconnecter la carte à Internet, éxecutez la commande suivante :
#sudo systemctl disable hostapd
#Veuillez noter que la connexion en SSH fonctionne aussi trés bien à travers le point d'accés. Vous pouvez ainsi directement coller vos fichiers et sites webs dans le répertoire "www/votrebox.box/public_html" en utilisant, avec votre IP à la place de l'example, la commande "sudo scp /home/votrepc/votresite votrepi@192.168.1.19:/home/votrepi/var/www/votrebox.box/public_html". Vous pouvez héberger tout ce que vous voulez, c'est votre serveur , et votre Internet ! Ex: blogs ou CMS tels que PluxMl,Wordpress(necessite de configurer une base de données Mysql , facilement avec phpmyadmin), tout le HTML/JS/CSS, scripts php de toute nature, etc... POur exécuter du Javascript en back-end, installez node.js et npm. (voir doc : liens)


#Vous devriez pouvoir désormais vous connecter à votre point d'accés-Stand Alone-portail captif , aussi appélé "NAT", avec le SSID que vous avez défini, sans mot de passe.
#Vous pouvez customiser la splash page du portail captif en éditant: "/etc/nodogsplash/htdocs/splash.html" (ajoutez photos, logo, mais pas de liens, voir doc: https://nodogsplashdocs.readthedocs.io/en/stable/customize.html )
#phpmyadmin devrait étre accessible avec votre navigateur à l'adresse "http://localhost/phpmyadmin", ou "http://localhost.phpmyadmin"