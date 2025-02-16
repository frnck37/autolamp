markdown

# Autolamp: 10 minutes Pi Box Server installation

A Bash script to automate the installation and configuration of an Open Offline Access Point Apache web server on Raspberry Pi 4, currently running Ubuntu Mate 22.04 - Jammy, but should work on other Debian and Ubuntu distros.

## Get the autolamp script:

wget https://github.com/frnck37/autolamp/blob/main/autolamp.sh

### Few things to do to install:
Let's consider yu have access to your Ubuntu Mate console, either directly or using ssh.

1. **Configure your Raspberry Pi's internet connection via "bluetooth"**. The easiest way is to share your phone's connection. You won't be able to use the Wi-Fi interface (`wlan0`) once the installation is complete, and your Pi must be connected, even at a very low speed, for the captive portal to work. When configured, this connexion must be set on "priority:10". Then, you must have SSH server enabled on your Rapsberrypi. Type 'sudo systemctl enable ssh' in your Rapsberrypi console prior to anything.

2. **Edit the `autolamp.sh` file**: `sudo nano autolamp.sh`.

3. **Change the hostnames** to your liking, lines 13 to 16.

4. **Adjust virtual server settings**, lines 20 to 57. Run the `ifconfig` command in the terminal to display the status of your interfaces and their IP addresses.

5. **Change the SSID** of your access point as desired, line 100.

6. **Specify the IP** of your `wlan0` interface in the `dnmasq` configuration, line 110.

7. **Do the same** in the captive portal configuration `GateWayAddress=192.168.X.X`, line 130. You can now close your file. (ctrl+o, puis ctrl+x)

8. **Run** `sudo ./autolamp.sh` in your terminal. The installation will begin.

9. **The secure installation of MySQL starts automatically at the end of the script.** Answer the questions as follows:
   - Change the root password? Yes, then "0"
   - Remove anonymous users? Yes
   - Disallow root login remotely? Yes
   - Remove test database and access it? Yes
   - Reload privilege tables now? Yes

10. MySQL is installed and configured, with no password for root. You can later connect to verify and perform any operations you want. (See MySQL documentation.)

11. To caonnect to Mysql later, **Run** `sudo mysql -u root -p` to connect as root first log to the MySQL server, without a password.

12. After rebooting, your Pi should start in access point mode, therefore not connected to the internet, in "Stand-Alone Access Point" mode.You can try to connect to it, using any device, and you should see the Portal slash page. You should now be able to connect to your Stand Alone Captive Portal access point, also known as "NAT", with the SSID you have defined, without a password. 
    You can customize the captive portal splash page by editing: `/etc/nodogsplash/htdocs/splash.html` (add photos, logo, but no links, see documentation: [nodogsplash customization](https://nodogsplashdocs.readthedocs.io/en/stable/customize.html))

13. To stop the access point and reconnect the card to the internet, execute the following command: `sudo systemctl disable hostapd` . If you are in Access Point mode, you can first connect to the AP, and then connect by ssh to your Rapsberrypi console . (see ssh doc, there is a lot !)

14. Please note that SSH connection works very well through the access point. You can directly paste your files and websites into the directory `www/yourbox.box/public_html` using, with your IP instead of the example, the command `sudo scp /home/yourpc/yoursite yourpi@192.168.1.19:/home/yourpi/var/www/yourbox.box/public_html`. You must have SSH server enabled on your Rapsberrypi. Type 'sudo systemctl enable ssh' in your Rapsberrypi console prior to anything.

15. You can host whatever you want, it's your server, and your internet! For example, blogs or CMS like PluxMl, Wordpress (requires configuring a MySQL database, easily done with phpMyAdmin), all HTML/JS/CSS, PHP scripts of any kind, etc. Simply put your files in your virtual hosts directories : '/var/www/yourbox.box/public_html', or '/var///www/local.box/public_html' in the present example.

16. To execute Javascript on the backend, install 'node.js' and 'npm'. (see documentation, there is a lot !)

17. phpMyAdmin should be accessible with your browser at the address `http://localhost/phpmyadmin`, or `http://localhost.phpmyadmin`. On first boot Username should be "root", and password is blank. Or try your Rapsberrypi username/sudo password.

18. The script automatically perform the installation of the webmin interface on your web server. You can then administrate  your entire rapsberrypi system using the web interface at : https://localhost:10000, or https://yourip:10000. The password on first login should be "root" and "root", or your system login.(rapsberrypi username and sudo password)

###You can now add these local url to your browser:

https://localhost:10000 
The webmin interface

http://localhost/phpmyadmin
The phpmyadmin login, to administrate your databases

http://yourbox.box/  
Your first Host(example)

http://local.box 
Your second Host(example)

...and you have a well working portable web server, and everything to administrate it using simply the access point.
Webmin offers edition capacities, but you can also ,from the Access Point, connect with the ssh protocol, and edit any system file as admin.

**Please** note that it is not possible to use ssl/tls (to use "https://..." requests) running in Stand Alone Network, because the certificate needs a registered domain, from wich he confirms his validity. As you're not connected to the Internet(Port opening is not possible on iPhone and Androïd)  and have no publicly registered domain, you can't use SSL/TLS.
Your sites will always be accessible using only "http://..." requests. Despite minor risks, it's a problem because you can not serve "webapp" for example.Any suggestions upon this particular point would be welcome ! But you can add security fixes to your server, depending  your use.(Search for "apache2 security" tutos.)

Please note that there is a potential social disruptive disorder in this script. But just like earthquake, asteroids,tsunamis, it's there. The rest is up to you, and your idea of love.


