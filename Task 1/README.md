# Task 1

This repository contains Task №1 for Internship from Mobidev.

Task 1 represents usage of Rack web server and creating reports from database.

## Usage

## Challenge 1

Challenge 1 folder contains a picture of database design for the project.

![DatabaseDesign](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/Challenge 1/database_design.png?raw=true>)

## Challenge 2

Challenge 2 folder contains 2 ruby files.

`create_database.rb` file creates database if not exists typing in terminal

> ruby create_database.rb

`drop_database.rb` file drops database if exists typing in terminal:

> ruby drop_database.rb

## Challenge 3

Challenge 3 folder contains web rack app. (challenges from 3 to 7)

Before starting the project, you need to start `bundler install` in terminal, it`ll install all needed gems.

To start the project, type in terminal

> rackup

Challenge 3 represents visual interface for parsing .csv data into postgresql database.

![Challenge3](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge3.png?raw=true>)

## Challenge 4

Challenge 4 represents visual report for states using a postgresql database.

This challenge is available after command `rackup` on local address:

> `http://127.0.0.1:9292/reports/states`

![Challenge4basic](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge4basic.png?raw=true>)

And also it is implemented for any exact state on special local address (for example, ca):

> `http://127.0.0.1:9292/reports/states/ca`

![Challenge4adv](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge4adv.png?raw=true>)

## Challenge 5

Challenge 5 represents visual Fixture Type Count report for offices.

This challenge is available after command `rackup` on local address:

> `http://127.0.0.1:9292/reports/offices/fixture_types`

![Challenge5basic](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge5basic.png?raw=true>)

And also it is implemented for any exact office id on special local address (for example, 1):

> `http://127.0.0.1:9292/reports/offices/1/fixture_types`

![Challenge5adv](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge5adv.png?raw=true>)

## Challenge 6

Challenge 6 represents visual Marketing Materials Costs report.

This challenge is available after command `rackup` on local address:

> `http://127.0.0.1:9292/reports/materials`

![Challeng6basadv](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge6basadv.png?raw=true>)

## Challenge 7

Challenge 7 represents visual Office Installation Instructions report.

This challenge is available after command `rackup` on local address:

> `http://127.0.0.1:9292/reports/offices/1/installation`

![Challeng7basic](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge7basic.png?raw=true>)

And also it is implemented like list with the search, so you can choose any office:

> `http://127.0.0.1:9292/reports/offices/installation`

![Challeng7adv](<https://github.com/SansNumbers/RubyDevChallenges/blob/main/Task 1/images/challenge7adv.png?raw=true>)
