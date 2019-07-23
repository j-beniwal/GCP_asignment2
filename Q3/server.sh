#! /bin/bash
apt-get update
apt-get install -y apache2 
rm /var/www/html/index.html
echo "<html><body><h1>Hello People</h1><h2>hi Welcome to Jeevan's webpage </h2></body></html>" >> /var/www/html/index.html
