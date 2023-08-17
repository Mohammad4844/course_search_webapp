# Rails Web API for Course Search

This is the webapp for use with emu courses database as an api for searching.

## Instructions for setup
1) Clone this repository
2) `cd` into this repo and `bundle install` the dependencies
3) Declare the env variables for the postgres database connection
    - env variables: DB_HOST, DB_NAME, DB_USER, DB_PASS
    - port is assumed to be 5432
4) Add any cors (Cross-origin Requests) domains in `config/application.rb`
5) Start the server with `rails server
