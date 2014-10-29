# -*- coding: utf-8 -*-
ENV['RACK_ENV'] = 'test'
require_relative '../app.rb'
require 'test/unit'
require 'minitest/autorun'
require 'rack/test'
require 'selenium-webdriver'
require 'rubygems'

include Rack::Test::Methods

def app
   Sinatra::Application
end

describe "Test APP Estadisticas Urls Cortas: Comprobacion de enlaces y acceso" do
   
   before :each do
	  @browser = Selenium::WebDriver.for :firefox
	  @site = 'http://sytw5.herokuapp.com/'
	  if (ARGV[0].to_s == "local")
		 @site = 'localhost:9292/'
	  end
	  @browser.get(@site)
   end

   it "I can see signin page" do
#  	  @browser.get('localhost:9292')
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"enter") }
 	  ensure
		 element = element.text.to_s
# 		 puts "element = #{element}"
		 assert_equal(true, element.include?("SIGN IN WITH GOOGLE"))
		 @browser.quit
	  end
   end

   it "The designers' links go right: Aaron Vera Cerdeña" do
	  @browser.manage.timeouts.implicit_wait = 5
	  @browser.find_element(:id,"aa1").click
	  assert_equal("https://github.com/alu0100537451",@browser.current_url)
	  @browser.quit
   end
   
   it "The designers' links go right: Aaron Socas Gaspar" do
	  @browser.manage.timeouts.implicit_wait = 5
	  @browser.find_element(:id,"aa2").click
	  assert_equal("http://alu0100207385.github.io/",@browser.current_url)
	  @browser.quit
   end

   it "I can access google login page" do
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 element = wait.until { @browser.find_element(:id,"link-signup") }
		 element = element.text.to_s
		 if (element.include?("Create an account") == true) or (element.include?("Crear una cuenta") == true) #controlamos que nos redirija a la version inglesa
			control = true
		 end
# 		 puts "control = #{control}"
		 assert_equal(true, control)
		 @browser.quit
	  end
   end

   it "If User did not log in, it  will be redirected to signin page" do
	  @browser.get(@site+'user/index')
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element = element.text.to_s
		 assert_equal(true, element.include?("SIGN IN WITH GOOGLE")) #No se ha podido acceder pq no esta logueado, volvemos a /sigin
		 @browser.quit
	  end
   end

   it "I can access user/index" do
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 @browser.find_element(:id,"Email").send_keys("usu0100")
		 @browser.find_element(:id,"Passwd").send_keys("sytw20142015")
		 @browser.find_element(:id,"signIn").click
		 @browser.manage.timeouts.implicit_wait = 6
		 if  @browser.find_element(:id,"submit_approve_access").displayed?
			@browser.find_element(:id,"submit_approve_access").send_keys:return
		 end
# 		 @browser.find_element(:id,"submit_approve_access").click
		 begin
			element = wait.until { @browser.find_element(:id,"usu") }
		 ensure
			element = element.text.to_s
			assert_equal(true, element.include?("USU DE PRUEBA"))
			@browser.quit
		end
	  end
   end


end