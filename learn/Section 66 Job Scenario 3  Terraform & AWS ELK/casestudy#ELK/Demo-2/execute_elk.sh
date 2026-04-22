##################################################################  
#  1. install Elastic Search
##################################################################

# Update Unix Machine Package Manager
sudo apt-get update
sudo apt-get upgrade -y


# Install JAVA on Machine:
sudo apt-get install default-jre -y
java -version

# Elasticsearch Installation
# wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
# echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
# echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo -s
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.3.3-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.3.3-linux-x86_64.tar.gz.sha512
shasum -a 512 -c elasticsearch-9.3.3-linux-x86_64.tar.gz.sha512
tar -xzf elasticsearch-9.3.3-linux-x86_64.tar.gz
cd elasticsearch-9.3.3/



# Install ES:
sudo apt-get update
sudo apt-get install elasticsearch -y


# Update ES Network Config:
sudo vim /etc/elasticsearch/elasticsearch.yml
network.host: "localhost"
http.port:9200

sudo vim /etc/elasticsearch-9.3.3/elasticsearch-9.3.3/config/elasticsearch.yml
network.host: "localhost"
http.port:9200


# Start EC Service:
sudo service elasticsearch start
sudo service elasticsearch status

# Verify ES Service Status:
sudo curl http://localhost:9200



##################################################################  
#  2. install logstash
##################################################################

# Logstash Installation
sudo apt-get install logstash



##################################################################  
#  3. install kibana
##################################################################

# Installing Kibana
sudo apt-get install kibana
sudo service kibana status


# Update Kibana Network Setting:
vim /etc/kibana/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]


# Start Kibana Service:
sudo service kibana start



##################################################################  
#  4. install Beats
##################################################################

# Installing Beats
sudo apt-get install metricbeat
sudo service metricbeat status
sudo service metricbeat start
sudo service metricbeat status

# Shipping some data:
sudo vim /etc/logstash/conf.d/apache-01.conf

# input {
# file {
# path => "/home/ubuntu/apache-daily-access.log"
# start_position => "beginning"
# sincedb_path => "/dev/null"
# }
# }
 
# filter {
# grok {
# match => { "message" => "%{COMBINEDAPACHELOG}" }
# }
 
# date {
# match => [ "timestamp" , "dd/MMM/yyyy:HH:mm:ss Z" ]
# }
 
# geoip {
# source => "clientip"
# }
# }
 
# output {
# elasticsearch {
# hosts => ["localhost:9200"]
# }
# }


# Start LogStash Service:
sudo service logstash start
sudo service logstash status