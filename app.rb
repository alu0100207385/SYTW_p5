#!/usr/bin/env ruby
require 'bundler/setup'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader' if development?
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'pry'
require 'haml'
require 'rubygems'
require 'uri'
require 'data_mapper'
require 'erubis'
require 'pp'

# set :erb, :escape_html => true
set :environment, :development
set :protection , :except => :session_hijacking

Base = 36

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

# Creamos la bd
configure :development do
   DataMapper.setup( :default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
end
=begin
configure :production do
   DataMapper.setup(:default,ENV['HEROKU_POSTGRESQL_RED_URL'])
end
=end
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative 'model'

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, '*&(^#234a)'

get '/' do
    haml :signin
end


get '/auth/:name/callback' do
    config = YAML.load_file 'config/config.yml'
    case params[:name]
    when 'google_oauth2'
	  @auth = request.env['omniauth.auth']
      session[:name] = @auth['info'].name
	  session[:email] = @auth['info'].email
# 	  session[:image] = @auth['info'].image
      redirect "user/index"
    else
      redirect "/auth/failure"
    end
end

get '/user/:webname' do
  if (session[:name] != nil)
    case(params[:webname])
    when "index"
      @user = session[:name]
# 	  @user_img = session[:image]
	  email = session[:email]
	  @list = ShortenedUrl.all(:order => [:id.asc], :email => email , :limit => 20)
      haml :index
    end
  else
    redirect '/'
  end
end


post '/user/:webname' do
#   puts "inside post '/': #{params}"
  if (session[:name] != nil)
    uri = URI::parse(params[:url])
    if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
      begin
		 @short_url = ShortenedUrl.first_or_create(:url => params[:url] , :email => session[:email] , :label => params[:label])
		 rescue Exception => e
		 puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
		 pp @short_url
		 puts e.message
      end
    else
      logger.info "Error! <#{params[:url]}> is not a valid URL"
    end
    redirect '/user/index'
  end
  redirect '/'
end


get '/user/index/logout' do
  puts "SALIENDO...."
  if session[:auth]
    session[:auth] = nil;
  end
  session.clear
  redirect '/'
end


get '/user/index/close_sesion' do
  session.clear
  redirect 'https://accounts.google.com/Logout'
end


delete '/user/index/del/:url' do
#    puts "#{params[:url]}"
   if (params[:url] == 'all')
	  @short_url = ShortenedUrl.all(:order => [:id.asc], :email => session[:email] , :limit => 20)
	  @short_url.all.destroy
   else
	  aux = ShortenedUrl.all(:order => [:id.asc], :email => session[:email])
	  if (aux.length != 0) then
		 begin
			aux = ShortenedUrl.first(:email => session[:email], :id => params[:url])
			aux.destroy if !aux.nil?
			rescue Exception => e
			puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
			pp @short_url
			puts e.message
		 end
	  end
   end
   redirect '/user/index'
end


get '/user/index/:shortened' do
   puts "ENTRO EN :shortened"
   puts "inside get '/user/index/:shortened': #{params}"
   short_url = nil
   short_url = ShortenedUrl.first(:label => params[:shortened])
   if short_url == nil
	  short_url = ShortenedUrl.first(:id => params[:shortened].to_i(Base))
   end
   redirect short_url.url, 301
end


get '/auth/failure' do
  flash[:notice] =
    %Q{<h3>Se ha producido un error en la autenticacion</h3> &#60; <a href="/">Volver</a> }
#  redirect '/'
end

error do haml :signin end
