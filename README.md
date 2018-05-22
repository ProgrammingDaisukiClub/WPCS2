# WPCS2

Waseda Programming Contest System 2  
https://wpcs2.herokuapp.com

[![wercker status](https://app.wercker.com/status/252b5ef09b779ef907f68c6b9b43a192/m/master "wercker status")](https://app.wercker.com/project/byKey/252b5ef09b779ef907f68c6b9b43a192)

## Requirements

* Ruby: 2.5.1
  * bundler: 1.15.2
  * Rails: 5.1.6
* Node: 8.11.2
  * npm: 5.6.0
* TypeScript: 2.1.6
  * React: 16.3.2
  * webpack: 4.8.3
* PostgreSQL: 9.6.8

## Setup for development environment

for ubuntu 18.04

```sh
# install rbenv and ruby-build
# see https://github.com/rbenv/rbenv#basic-github-checkout
# see https://github.com/rbenv/ruby-build#installation
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# install Ruby
rbenv install 2.5.1
rbenv global 2.5.1

# install bundler
gem install bundler -v '1.15.2'

# install nvm
# see https://github.com/creationix/nvm#installation
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bash_profile
source ~/.bash_profile

# install node
nvm install 8.11.2

# install PostgreSQL
# for other versions of ubuntu or other operating systems
# see https://www.postgresql.org/download/
sudo localectl set-locale LANG=en_US.utf8
sudo apt-add-repository 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install -y postgresql-9.6 libpq-dev 

# create postgresql role
# enter password
sudo -u postgres createuser vagrant -s -P

# clone this repository
git clone https://github.com/ProgrammingDaisukiClub/WPCS2.git ~/WPCS2
cd ~/WPCS2

# create .env and edit it
cp .env.sample .env

# install ruby gems
bundle install

# install npm packages
npm install

# create database
bundle exec rake db:create

# migrate database
bundle exec rake db:migrate

# build javascript with webpack
npm run dev-build
```

## Run development server

```
bundle exec rails server -b 0.0.0.0
```

## Run lint tools

```
# run rubocop
bundle exec rubocop -a

# run tslint
npm run fix
```

## Run tests

```
# run minitest
bundle exec rake test

# run rspec
bundle exec
```

## More information

See our Wiki.  
https://github.com/ProgrammingDaisukiClub/WPCS2/wiki
