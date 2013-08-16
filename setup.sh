###########################
# FCMS SETUP INSTRUCTIONS #
###########################
apt-get install build-essential
apt-get install openssh-server
apt-get install apache2							# serveur web
apt-get install mysql-server libmysqlclient-dev				# pour gem mysql2
apt-get install libxml2-dev libxslt1-dev 					# pour gem nokogiri
apt-get install git

########################
# RVM AND RUBY INSTALL #
########################
apt-get install curl
curl -L https://get.rvm.io | bash -s stable
rvm requirements
rvm install 1.9.3
rvm use 1.9.3 --default
rvm rubygems current
chown -R root:rvm /usr/local/rvm					# des fois les permissions sucks
adduser fcms								# creer un user fcms
usermod -a -G rvm fcms							# ajouter le user fcms au groupe rvm
su fcms
echo 'export RAILS_ENV=production' >> ~/.bashrc			# toujours etre en mode production

#############################
# PHUSION PASSENGER INSTALL #
#############################
apt-get install libcurl4-openssl-dev apache2-threaded-dev libapr1-dev libaprutil1-dev
gem install passenger
passenger-install-apache2-module

########################################
# SETUP GIT BRANCH AND DATABASE CONFIG #
########################################
# DEVELOP BRANCH
mkdir develop
cd develop
git init
git remote add -t develop -f origin git@github.com:Inovitex/fcms.git
git checkout develop
bundle install
git update-index --assume-unchanged config/database.yml

# DB
mysql -u root -p
CREATE DATABASE fcms_develop;
GRANT ALL ON fcms_develop.* TO fcms_develop@localhost IDENTIFIED BY '2eC#uWaH6D9u';
vi config/database.yml							# update to the new database config

# PRODUCTION BRANCH
mkdir production
cd production
git init
git remote add -t master -f origin git@github.com:Inovitex/fcms.git
git checkout master
bundle install
git update-index --assume-unchanged config/database.yml

# DB
mysql -u root -p
CREATE DATABASE fcms_production;
GRANT ALL ON fcms_production.* TO fcms_production@localhost IDENTIFIED BY '8&g9vaBe@!b2';
vi config/database.yml							# update to the new database config
