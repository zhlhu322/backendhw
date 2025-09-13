# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

* table schema
* User{
*   userID
*   name string
*   missions[]
*   manager boolean  
* }
* mission{
*  userID
*  name string
*  description text
*  startDate
*  endDate
*  priority
*  state
*  tag
* }
