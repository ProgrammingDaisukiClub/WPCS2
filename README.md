# WPCS2

Waseda Programming Contest System 2

[![wercker status](https://app.wercker.com/status/252b5ef09b779ef907f68c6b9b43a192/m/master "wercker status")](https://app.wercker.com/project/byKey/252b5ef09b779ef907f68c6b9b43a192)

## Requirements

* Ruby: 2.4.0

* Node: 7.5.0

* npm: 4.1.2

## How to deploy

1. Make sure you have been installed following gems
  - `rails`
  - `railties`
  - `bundler`

1. Install nodejs and npm

1. Install webpack using npm
  ```
  sudo npm install webpack -g
  ```

1. Install gems using bundler
  ```
  bundle install
  ```

1. Install nodejs packages
  ```
  npm install
  ```
  
1. Build JavaScripts
  ```
  npm run dev-build    # for development (build)
  npm run dev-watch    # for development (watch)
  npm run prod         # for production
  ```

1. Run db migration
  ```
  rake db:migrate
  ```

1. Run rails server
  ```
  bundle exec rails s -b 0.0.0.0
  ```

## For developers
You may need to run following commands after pulling some changes.
```
bundle install
rake db:migrate
npm install
npm run dev-build
```

Following command is useful for front-end developer. (auto building Javascript)
```
npm run dev-watch
```
