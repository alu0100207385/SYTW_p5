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
require 'chartkick'

# set :erb, :escape_html => true
set :environment, :development
set :protection , :except => :session_hijacking

Base = 36

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

# Creamos la bd
configure :development, :test do
   DataMapper.setup( :default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
end

configure :production do
   DataMapper.setup(:default,ENV['HEROKU_POSTGRESQL_RED_URL'])
end

DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative 'model'

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, '*&(^#234a)'

get '/' do
   @list = Shortenedurl.all(:order => [:id.asc], :email => nil)
   haml :signin
end


get '/auth/:name/callback' do
    config = YAML.load_file 'config/config.yml'
    case params[:name]
    when 'google_oauth2'
      @auth = request.env['omniauth.auth']
      session[:name] = @auth['info'].name
      session[:email] = @auth['info'].email
#     session[:image] = @auth['info'].image
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
#     @user_img = session[:image]
    email = session[:email]
    @list = Shortenedurl.all(:order => [:id.asc], :email => email)
      haml :index
    end
  else
    redirect '/'
  end
end


get '/help' do
   haml :help
end


get '/:url' do
   short_url = nil
   short_url = Shortenedurl.first(:label => params[:url])
   if short_url == nil
    short_url = Shortenedurl.first(:id => params[:url].to_i(Base))
   end
   @ip = request.ip
   xml = RestClient.get "http://api.hostip.info/get_xml.php?ip=#{@ip}"
   @country = XmlSimple.xml_in(xml.to_s,{ 'ForceArray' => false })['featureMember']['Hostip']['countryName']
   Visit.first_or_create(:ip => @ip, :created_at => Time.now,:country => @country, :shortenedurl => short_url)
   redirect short_url.url, 301
end



get '/statistics/:url' do
   @list = Shortenedurl.all(:order => [:url.asc], :email => nil)
   @country = Hash.new
   @date = Hash.new

   @url = Shortenedurl.first(:id => params[:url].to_i(Base))
   visit = Visit.all(:shortenedurl => @url)
   visit.each{ |v|
#       id = v.shortenedurl_id
   if (@country[v.country] == nil)
    @country[v.country] = 1
   else
    @country[v.country] += 1
   end

   if(@date["#{v.created_at.day} - #{v.created_at.month} - #{v.created_at.year}"] == nil)
    @date["#{v.created_at.day} - #{v.created_at.month} - #{v.created_at.year}"] = 1
   else
    @date["#{v.created_at.day} - #{v.created_at.month} - #{v.created_at.year}"] += 1
   end
   }
   haml :statistics
end

get '/user/index/mystatistics/:url' do
  @user = session[:name]
  @list = Shortenedurl.all(:order => [:url.asc], :email => session[:email])
  @visits = Visit.all
  @country = Hash.new
  @date = Hash.new
  @url = Shortenedurl.first(:id => params[:url].to_i(Base), :email => session[:email])
  visit = Visit.all(:shortenedurl => @url)
  visit.each{ |v|
     if (@country[v.country] == nil)
      @country[v.country] = 1
     else
      @country[v.country] += 1
     end
     if(@date["#{v.created_at.day} - #{v.created_at.month} - #{v.created_at.year}"] == nil)
      @date["#{v.created_at.day} - #{v.created_at.month} - #{v.created_at.year}"] = 1
     else
      @date["#{v.created_at.day} - #{v.created_at.month} - #{v.created_at.year}"] += 1
     end
  }
  haml :mystatistics
end

post '/' do
#   puts "inside post '/': #{params}"
  if (session[:name] == nil)
    uri = URI::parse(params[:url])
    if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
      begin
     @short_url = Shortenedurl.first_or_create(:url => params[:url] , :email => nil , :label => params[:label])
     rescue Exception => e
     puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
     pp @short_url
     puts e.message
      end
    else
      logger.info "Error! <#{params[:url]}> is not a valid URL"
    end
  end
  redirect '/'
end

post '/user/:webname' do
#   puts "inside post '/': #{params}"
  if (session[:name] != nil)
    uri = URI::parse(params[:url])
    if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
      begin
     @short_url = Shortenedurl.first_or_create(:url => params[:url] , :email => session[:email] , :label => params[:label])
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


get '/user/index/:url' do
   case(params[:url])
   when "logout"
#     puts "SALIENDO...."
    if session[:auth]
     session[:auth] = nil;
    end
    session.clear
    redirect '/'
   when "close_sesion"
    session.clear
    redirect 'https://accounts.google.com/Logout'
   else #acceder a la url
    @list = nil
    @list = Shortenedurl.first(:label => params[:url])
    if @list == nil
     @list = Shortenedurl.first(:id => params[:url].to_i(Base))
    end
    @ip = request.ip
#     @list.n_visit += 1
#     @list.save
    xml = RestClient.get "http://api.hostip.info/get_xml.php?ip=#{@ip}"
    @country = XmlSimple.xml_in(xml.to_s,{ 'ForceArray' => false })['featureMember']['Hostip']['countryName']
    Visit.first_or_create(:ip => @ip, :created_at => Time.now,:country => @country, :shortenedurl => @list)
    redirect @list.url, 301
   end
end


delete '/del/:url' do
   aux = Shortenedurl.all(:order => [:id.asc], :email => nil)
   if (aux.length != 0) then
    begin
     aux = Shortenedurl.first(:id => params[:url])
     aux.destroy if !aux.nil?
     rescue Exception => e
     puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
     pp @short_url
     puts e.message
    end
   end
   redirect '/'
end

delete '/user/index/del/:url' do
#    puts "#{params[:url]}"
#    if (params[:url] == 'all')
   case(params[:url])
   when "all"
    @short_url = Shortenedurl.all(:order => [:id.asc], :email => session[:email])
    if (@short_url.length != 0)
     @short_url.all.destroy
    end
   else
    aux = Shortenedurl.all(:order => [:id.asc], :email => session[:email])
    if (aux.length != 0) then
     begin
      aux = Shortenedurl.first(:email => session[:email], :id => params[:url])
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

get '/auth/failure' do
  flash[:notice] =
    %Q{<h3>Se ha producido un error en la autenticacion</h3> &#60; <a href="/">Volver</a> }
#  redirect '/'
end


error do haml :signin end
