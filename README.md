# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version "3.4.2"
* Rails version "8.0.2"

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
* Render web service
* https://missionmanager.onrender.com/

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
*  creat_at datetime
*  endDate datetime
*  priority
*  state
*  tag
* }
