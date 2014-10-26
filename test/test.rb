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
   
   before :all do
	  @browser = Selenium::WebDriver.for :firefox
   end
   
   it "I can see signin page" do
	  @browser.get('localhost:9292')
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"enter") }
 	  ensure
		 element = element.text.to_s
# 		  puts "element = #{element}"
		 assert_equal(true, element.include?("SIGN IN WITH GOOGLE"))
		 @browser.quit
	  end
   end

   it "I can access google login page" do
	  @browser.get('localhost:9292')
	  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 element = wait.until { @browser.find_element(:id,"link-signup") }
		 element = element.text.to_s
		 puts "element = #{element}"
		 assert_equal(true, element.include?("Crear una cuenta"))
		 @browser.quit
	  end
   end

end