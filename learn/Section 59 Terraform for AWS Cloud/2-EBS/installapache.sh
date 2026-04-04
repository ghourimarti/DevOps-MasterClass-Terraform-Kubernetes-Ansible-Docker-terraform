#! /bin/bash
apt-get update
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>Zoheeee  eeee   ee e e e e ee e Deployed Machine via Terraform</h1>" | sudo tee /var/www/html/index.html
