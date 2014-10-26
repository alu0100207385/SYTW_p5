source "http://rubygems.org"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-flash'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'pry'
gem 'erubis'
gem 'haml'
gem 'data_mapper'
gem 'thin'

group :production do
   gem 'do_postgres'
   gem 'pg'
   gem 'dm-postgres-adapter'
end

group :test, :development do
   gem 'sqlite3'
   gem 'dm-sqlite-adapter'
   gem 'rack-test'
   gem 'rake'
   gem 'minitest'
   gem 'test-unit'
   gem 'selenium-webdriver'
end
