# Markt-Engine (RoR e-commerce platform)

## Overview

This is a turnkey solution for e-commerce (online store).

If you want to quickly launch your online store this platform is for you.

It's provides the functionality for customers and merchants to make and manage purchases. 
It's includes handy admin panel to reach high level usability for merchants. 
This solution is ready to use on mobile screens.

## DEMO

Take a look at The [Demo](https://market-engine.herokuapp.com). 
The login names is `super@example.com`, `admin@example.com`, 
`user_1@example.com`. You can see all user names in `db/seeds.rb`.
DB is reset every day. 

password => `123456` for all users.

## Used technologies

* Rails 5.2.0
* Ruby 2.4.1
* PostgreSQL
* Puma
* Bootstrap 4
* Image storage: `AWS S3` with `Carrierwave`
* Authorization: `Devise` 

## Getting Started

Install [RVM](https://rvm.io/) with Ruby 2.4.1.


Copy:
```
cp .env.example .env
cp config/database.yml.example config/database.yml
```
For `config/database.yml` update your `username/password`

Install gems:
```
gem install bundler
bundle install
```

##### Install DB

empty data:
```
rake db:create
rake db:migrate
```

or with fake data:

```
rake db:setup
```

## Environmental Variables

```
AWS_REGION             => your AWS region 
AWS_ACCESS_KEY_ID      => your access key id from AWS
AWS_SECRET_ACCESS_KEY  => your secret access key from AWS
AWS_S3_BUCKET          => your bucket name for Images
LOCALE                 => your default language
TIME_ZONE              => your default time zone
```

Most users are using Amazon S3 and Heroku. 
Before start the APP, must specify the ENV variables.
You should add the following ENV variables:
                                           
Local environment:

Just set data in `.env` file. If you want to use S3, 
please replace `:file` to `:fog` in `config/initializers/carrierwave.rb` 
at the end of the file. Otherwise(for now) your 
images will be stored locally in `public/uploads` directory.

On Heroku:

```
heroku config:add DEVISE_SECRET_KEY=xxxxxxxxxxxxxxx
heroku config:add AWS_REGION=xxxxxxxxxxxxxxx
heroku config:add AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxx
heroku config:add AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
heroku config:add AWS_S3_BUCKET=xxxxxxxxxxx
heroku config:add LOCALE=xxxxxxxxxxx
heroku config:add TIME_ZONE=xxxxxxxxxxx
```

## Usage

##### Main page

On the main page you can view all items and items 
of the selected category, perform a search, add 
several products to the cart. The item can be added 
to the cart only by an authorized user. 
The total amount of the order is displayed near 
the cart on the right in the Navbar. When ordering, 
you must specify the full shipping address and telephone 
number for communication.

##### Admin Panel

In the Admin Panel you can:

1. Manage items and categories: CRUD operations, 
move items from one category to another 
(necessary before removing the category).

2. Management of purchases: CRUD operations, 
review the status of the purchase and the 
history of all purchases.

3. User management: CRUD operations, 
assign roles to users. There are 3 roles 
available: Super user (not changeable) Admin and Standard user.

#### Running Tests

```
bundle exec rspec spec
```

## Locales and Time Zone

##### Locales   

Each user can choose a locale language from the footer. 
If the language is not selected, the language 
from the `ENV['LOCALE']` variable is used by default. 
Currently available `EN` and `RU`

##### Time Zone

The user can select the time zone when editing 
information about himself. If the time zone is 
not selected or user not authorized, the default 
is used time zone from the `ENV['TIME_ZONE']` variable. 
All time zones are available.

## Authors

Markt-Engine was created by:

* [Magomed Saipudinov](https://github.com/andiskiy)
* [Arsen Chikatuev](https://github.com/Sammy3124)

contacts: `saipudinov.magomed@gmail.com`