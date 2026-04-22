#!/bin/bash

echo "<----------------------------------------------------------------->"
echo "<------------------------- 1. apt update ------------------------->"
echo "<----------------------------------------------------------------->"
sudo apt update
sudo apt-get upgrade -y
sudo apt-get install default-jre -y
sudo java -version



echo "<----------------------------------------------------------------->"
echo "<----------------------- 3. install logstash --------------------->"
echo "<----------------------------------------------------------------->"
##################################################################  
#  2. install logstash
##################################################################
# install logstash
sudo apt-get install logstash
sleep 10

# Start LogStash
sudo mv /tmp/apache-01.conf /etc/logstash/conf.d/apache-01.conf
sleep 10
sudo service logstash start



echo "<----------------------------------------------------------------->"
echo "<----------------------- 4. install kibana ----------------------->"
echo "<----------------------------------------------------------------->"
##################################################################  
#  3. install kibana
##################################################################
# install kibana
sudo apt-get install kibana
sleep 10

sudo mv /tmp/kibana.yml /etc/kibana/kibana.yml
sudo service kibana start


echo "<----------------------------------------------------------------->"
echo "<----------------------- 5. install filebeats -------------------->"
echo "<----------------------------------------------------------------->"
##################################################################  
#  4. install filebeats
##################################################################
# install filebeats
sudo apt-get install metricbeat
sleep 10
sudo service metricbeat start



# echo "<----------------------------------------------------------------->"
# echo "<------------------- 2. install Elastic Search ------------------->"
# echo "<----------------------------------------------------------------->"
# ##################################################################  
# #  1. install Elastic Search
# ##################################################################
# # install elasticsearch
# # wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
# # echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
# # echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
# wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.3.3-linux-x86_64.tar.gz
# wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.3.3-linux-x86_64.tar.gz.sha512
# shasum -a 512 -c elasticsearch-9.3.3-linux-x86_64.tar.gz.sha512
# tar -xzf elasticsearch-9.3.3-linux-x86_64.tar.gz



# sudo apt-get update
# sudo apt-get install elasticsearch -y
# sleep 10
# # sudo mv /tmp/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
# sudo mv /tmp/elasticsearch.yml /etc/elasticsearch-9.3.3/elasticsearch-9.3.3/config/elasticsearch.yml

# sudo service elasticsearch start
# sudo service elasticsearch status
# sudo curl http://localhost:9200