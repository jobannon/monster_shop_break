![1D2E9EB9-84EE-4825-91C3-AAAE3BA19F07_1_105_c](https://user-images.githubusercontent.com/16090626/75725280-5f7efc80-5c9d-11ea-8fe6-0763dd1c92e9.jpeg)
# Welcome to CoffeeTown!   
  CoffeeTown is a ficitional exercise in creating a large-scale, E-commerce solution using Rails and Postgres.  The original project and exercise is called Monster Shop 

  CoffeeTown is hosted - [Here](https://protected-stream-03620.herokuapp.com)
## Learning Goals

### Rails
* Implement partials to DRY code
* Implement professional grade user authentication and namespacing thru
  sessions, Bcrypt, strong params and filters

### ActiveRecord 
* Demonstrate the use of ActiveRecord query calls to populate monolith with appropriate data 

### Databases 
* Understand one to many and many to many relational database techniques 
* Practice schema creation and model testing to enforce database requirements

### Contributors:
* Darren - @darren2802  
* Matt S - @msimon42
* Paul D - @PaulDebevec
* Josh O - @jtobannon

## Schema 
  <img width="954" alt="Screen Shot 2020-01-09 at 7 23 04 PM" src="https://user-images.githubusercontent.com/16090626/72127857-23c75680-332e-11ea-9530-73dfa3fae2b4.png">

## Setup

1. Typical Rails setup.  
  * bundle install (occasionally removing the Gemfile.lock and running bundle may be most effective)
  * rails db:{drop, migrate, seed, create}
  * rake rails to run the test suite
  * rails s to run the server

2. This is currently hosted on Heroku
  * https://jpmd-monster-shop.herokuapp.com/

3. Install software dependencies
  - Rails 5.1.x
  - PostgreSQL
  - 'bcrypt' (authentication)

## Highlights

1. Implement FactoryBot to test development
2. 100% model and feature test coverage via simplecov.

## User Roles available in this e-commerce solution

1. Visitor - this type of user is anonymously browsing our site and is not logged in
1. Regular User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order
1. Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out)
1. Admin User - a registered user who has "superuser" access to all areas of
   the application; user is logged in to perform their work

## Order Progression in this e-commerce solution

1. 'pending' means a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
2. 'packaged' means all merchants have fulfilled their items for the order, and has been packaged and ready to ship
3. 'shipped' means an admin has 'shipped' a package and can no longer be cancelled by a user
4. 'cancelled' - only 'pending' and 'packaged' orders can be cancelled

