# Layer Tech Challenge Back-End

This is the backend implementation of the tech challenge.

## How to run

1. clone the repo
2. `bundle install` install gems
3. `rails db:create` create database
4. `rails db:migrate` migrate database
5. put `TWITCH_AUTH_URL`, `IGDB_BASE_URL`, `IGDB_CLIENT_ID`, `IGDB_CLIENT_SECRET` in `.env` file
6. `rspec` run tests
7. `rails s` run server on `localhost:3000`
