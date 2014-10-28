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

describe "Test APP Estadisticas Urls Cortas" do
   
   before :each do
	  @browser = Selenium::WebDriver.for :firefox
	  @site = 'http://sytw5.herokuapp.com/'
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
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"aa1") }
 	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 element = wait.until { @browser.find_element(:class,"vcard-username") }
		 element = element.text.to_s
		 assert_equal(element, "alu0100537451")
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

end