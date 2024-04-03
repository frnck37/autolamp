Autolamp : 10 minutes Pi Box Server installation.


A Bash script to automate the installation and configuration of an Open Access Point Apache web server on Rapsberrypi 4, currently running Ubuntu Mate 22.04 4 - Jammy, but should work on other Debian and Ubuntu distros.

#get the autolamp script:

wget https://github.com/frnck37/autolamp/blob/main/autolamp.sh

Few things to do:

#Configure your Raspberry Pi's internet connection via "bluetooth". The easiest way is to share your phone's connection. You won't be able to use the Wi-Fi interface (wlan0) once the installation is complete, and your Pi must be connected, even at a very low speed, for the captive portal to work.

#Edit the "autolamp.sh" file:
sudo nano autolamp.sh

#Change the hostnames to your liking, lines 13 to 16.

#Adjust virtual server settings, lines 20 to 57. Run the "ifconfig" command in the terminal to display the status of your interfaces and their IP addresses.

#Change the SSID of your access point as desired, line 100.

#Specify the IP of your wlan0 interface in the dnmasq configuration, line 110.

#Do the same in the captive portal configuration "GateWayAddress=192.168.X.X" line 130.

#Run "sudo ./autolamp2.sh" in your terminal. The installation will begin.

#The secure installation of MySQL starts automatically at the end of the script. Answer the questions as follows:

Change the root password? Yes, then "0"
Remove anonymous users? Yes
Disallow root login remotely? Yes
Remove test database and access it? Yes
Reload privilege tables now? Yes

#MySQL is installed and configured, with no password for root. Connect to verify and perform any operations you want. (See MySQL documentation.)

Run "sudo mysql -u root -p" to connect as root to the MySQL server, without a password.

After rebooting, your Pi should start in access point mode, therefore not connected to the internet, in "Stand-Alone Access Point" mode.

To stop the access point and reconnect the card to the internet, execute the following command:
sudo systemctl disable hostapd

#Please note that SSH connection works very well through the access point. You can directly paste your files and websites into the directory "www/yourbox.box/public_html" using, with your IP instead of the example, the command "sudo scp /home/yourpc/yoursite yourpi@192.168.1.19:/home/yourpi/var/www/yourbox.box/public_html".

You can host whatever you want, it's your server, and your internet! For example, blogs or CMS like PluxMl, Wordpress (requires configuring a MySQL database, easily done with phpMyAdmin), all HTML/JS/CSS, PHP scripts of any kind, etc. 

To execute Javascript on the backend, install node.js and npm. (see documentation: links)

You should now be able to connect to your Stand Alone Captive Portal access point, also known as "NAT", with the SSID you have defined, without a password.

You can customize the captive portal splash page by editing: "/etc/nodogsplash/htdocs/splash.html" (add photos, logo, but no links, see documentation: https://nodogsplashdocs.readthedocs.io/en/stable/customize.html)

#phpMyAdmin should be accessible with your browser at the address "http://localhost/phpmyadmin", or "http://localhost.phpmyadmin"

