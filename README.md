# WPCS2

Waseda Programming Contest System 2  
https://wpcs2.herokuapp.com

## Requirements

* Ruby: 2.7.0
  * bundler: 1.17.2
  * Rails: 5.1.7
* Node: 11.14.0
  * npm: 6.9.0
* TypeScript: 2.1.6
  * React: 16.3.2
  * webpack: 4.8.3
* PostgreSQL: 9.6.8

## Setup docker based environment

```sh
sh docker.sh
```

## Setup for development environment
　
We recommend to use docker-compose based environment.

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
rbenv install 2.7.0
rbenv global 2.7.0

# install bundler
gem install bundler -v '1.17.2'

# install nvm
# see https://github.com/creationix/nvm#installation
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bash_profile
source ~/.bash_profile

# install node
nvm install 11.14.0

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
