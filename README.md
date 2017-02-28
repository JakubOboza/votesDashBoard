# VOTES DASHBOARD

* A rails application displays the results of a TV SMS voting campaign.
* A command line tool to import and pre process a logfile.

### Description of my approach
**and design decisions**

1. Create the command line script that imports the log file into the database.  

  - **my approach here is:**
    - Because you specified it as a comand line script, my translation of this is that this functionality is not part of the rails app, so this has to be run separately.  
    - So I create a ruby class of some kind of parser that does a basic check on the file discarding the non-'VOTE' lines and parses the rest according to the parsing rules and pushes them in the database.
    - It has a basic logging feedback so the user can check it the process was successful and how many lines were imported and how many discarded.    

  - **the parsing process:**
    - Open the file and push it line by line into a 'data' array to hold the data I'm using an array of arrays because the order of the elements matters.
    - parse the array items according to the specs and checks if a line is valid.
    - Strips the white space, non-utf-8 chars, empty lines
    - checks the data row length and the presence of the correct headers.
    - splits the value from the keys(headers) at ':' and pushes into an array prepared for database.

  - **push the parsed data into a database**:
    - postgres database, with data_mapper ORM. The coice is because I wanted something completely separate, standalone from the rails app as this script works and should work without the rails app.
    - the prepared data_to_db array new database entries being created in a "votes" table. All rows has 9 columns. All data goes in as "string".

2. Create a rails app

  - **General**
    - The app is for displaying purposes only, So making it a read only app to basically only for visualizing the data stored in the database.
 In the parser the main item was a 'vote' in the rails app I decided to make the main resource a 'campaign'.
 - **Model:**
    - campaing(s) model, connected to the existing postgres database using Active Records.
  - **Views:**
    - The main landing page with the list of the campaigns (that has data).
    - Detailed campaign page where an overview and the detailed results can be seen.
      - Displayed data:
        - Overview: All votes, All Valid vote, All invalid votes in the campaign.
        - Details section: Table of the choices, number of votes for each choise along with a percentage and all this sorted in descending order of the casted votes. (Winner is on top of table).
    - used bootstrap for styling, responsive, mobile first.


### Usage

#### General setup
```
Ruby version: 2.3.0
Postgres account.
clone repo
cd votesDashBoard
bundle install
  create database votesDashBoard_development, votesDashBoard_test
  rake auto_migrate (for DataMapper)
  (rake db:setup (for Active Records))  
rspec

```
#### Command line tool usage
```
ruby parsevotes.rb <path_to_space_sepatated_txt_file_to_parse>
e.g.: ruby parsevotes.rb votes.txt
```

**Try it online:** `https://votes-dashboard.herokuapp.com/`

#### User Stories

```
As a developer
So I can parse a logfile from an SMS campaign
I want to be able to run a parser command line tool.
```

```
As a manager
So I can see the result of a SMS campaign
I want to be able to see the results on a web page in a nicely formatted way.

```
![views](./public/votesDashBoard.png)
