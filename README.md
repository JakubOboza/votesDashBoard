# VOTES DASHBOARD

This rails application displays the results of a TV SMS voting campaign.
A command line tool to import and pre process a logfile.

### Description of my approach
**and design decisions**

1. Create the command line script that imports the log file into the database.
  - **my approach here is:**
    - Because you specified it as a comand line script, my translation of this is that this functionality is not part of the rails app, so this has to be run separately.  
    - So I create a ruby class of some kind of parser that does a basic check on the file discarding the non-'VOTE' lines and parses the rest according to the parsing rules and pushes them in the database.
    - It has a basic logging feedback so the user can check it the process was successful and how many lines were imported and how many discarded and which ones.

  - **the parsing process:**
    - Open the file and push it line by line into a 'data' array to hold the data I'm using an array of arrays because the order of the elements matters and a hash can not guarantee this condition.
    - parse the array items according to the specs
  - **push the parsed data into a database**:


2. Create a rails app
 - The app is for displaying purposes only, So making it a read only app to basically only for visualizing the data stored in the database.




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
