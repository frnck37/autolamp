
#!/bin/bash

# Update package lists
sudo apt update

# Install LAMP server
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip php-xmlrpc php-soap -y

sudo apt install phpmyadmin

sudo phpenmod mysqli

sudo mkdir -p /var/www/yoursite/
sudo chown -R (user)/var/www/yoursite/
sudo mkdir -p /var/www/secondsite/
sudo chown -R (user)/var/www/secondsite/

sudo chmod -R 777 /var/www/

# Configure Apache for virtual host yoursite
sudo bash -c 'cat > /etc/apache2/sites-available/yoursite.conf << EOF
<VirtualHost *:80>
    ServerAdmin youremail@mail.com
    ServerName yoursite
    DocumentRoot /var/www/yoursite/public_html

    <Directory /var/www/yoursite>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'
# Configure Apache for virtual host secondsite.box
sudo bash -c 'cat > /etc/apache2/sites-available/secondsite.box.conf << EOF
<VirtualHost *:80>
    ServerAdmin youremail@mail.com
    ServerName secondsite.box
    DocumentRoot /var/www/secondsite.box/public_html

    <Directory /var/www/secondsite.box>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Enable the virtual host
sudo a2ensite yoursite.conf
sudo a2ensite secondsite.conf
sudo a2dissite 000-default.conf

# Restart Apache
sudo systemctl restart apache2

sudo rm /var/www/html/index.html
sudo echo "<?php phpinfo();?>"> /var/www/html/index.php

sudo chmod a+rw -R /var/www/

sudo /etc/init.d/apache2 restart

sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

sudo /etc/init.d/apache2 restart

sudo systemctl restart apache2

sudo a2enmod rewrite

sudo apache2ctl configtest

sudo apt-get install isc-dhcp-server -y

sudo bash -c 'cat > /etc/apache2/sites-available/yoursite.conf << EOF
"INTERFACESv4="wlan0"
"INTERFACESv6=""
EOF'

sudo bash -c 'cat > /etc/apache2/sites-available/yourdsite.conf << EOF
 net.ipv4.ip_forward=1
EOF'

sudo bash -c 'cat > /etc/apache2/sites-available/secondsite.conf << EOF
"INTERFACESv4="wlan0"
"INTERFACESv6=""
EOF'

sudo bash -c 'cat > /etc/apache2/sites-available/secondsite.conf << EOF
 net.ipv4.ip_forward=1
EOF'


# Install packages for access point
sudo apt install hostapd dnsmasq -y

# Configure access point
sudo bash -c 'cat > /etc/hostapd/hostapd.conf << EOF
interface=wlan0
driver=nl80211
ssid=yourssid
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


# Path to the hostapd configuration file
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"

# Uncomment the DAEMON_CONF line and set its value to the hostapd configuration file path
sudo sed -i 's/#\?DAEMON_CONF=.*/DAEMON_CONF="'"$HOSTAPD_CONF"'"/' /etc/default/hostapd
    
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


#On installe le dépot pour webmin(interface web auto hébérgée de gestion de système. See: http://webmin.com)
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sh setup-repos.sh
#On installe webmin
apt-get install webmin --install-recommends

#installation automatique sécurisée de Mysql
sudo /usr/bin/mysql_secure_installation 

#on désactive le network-manager. Attention, on perdra ensuite la connexion wifi ! Vérifiez que votre pi est connectée par bluetooth avant de lancer le script.
systemctl stop NetworkManager.service
echo "Network Manager stopped"
systemctl disable NetworkManager.service
echo "Network Manager disabled"
#on lance les services : portail captif, puis config sécurisée mysql

# Start services
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq

sudo cp ~/nodogsplash/debian/nodogsplash.service /lib/systemd/system/
sudo systemctl enable nodogsplash.service 

# Finish
echo "LAMP server OK."
