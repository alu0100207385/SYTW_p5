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

describe "Test APP Estadisticas Urls Cortas: Comprobacion de enlaces" do

   before :each do
	  @browser = Selenium::WebDriver.for :firefox
	  @site = 'http://sytw5.herokuapp.com/'
	  if (ARGV[0].to_s == "local")
		 @site = 'localhost:9292/'
	  end
	  @browser.get(@site)
	  @wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
   end

   it "I can see signin page" do
	  begin
		 element = @wait.until { @browser.find_element(:id,"enter") }
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
	  begin
		 element = @wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 element = @wait.until { @browser.find_element(:id,"link-signup") }
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
	  begin
		 element = @wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element = element.text.to_s
		 assert_equal(true, element.include?("SIGN IN WITH GOOGLE")) #No se ha podido acceder pq no esta logueado, volvemos a /sigin
		 @browser.quit
	  end
   end

end


# ***************************************************************************
describe "Test APP Estadisticas Urls Cortas: Entrada-salida del sistema" do
   
   before :all do
	  @browser = Selenium::WebDriver.for :firefox
	  @site = 'http://sytw5.herokuapp.com/'
	  if (ARGV[0].to_s == "local")
		 @site = 'localhost:9292/'
	  end
	  @browser.get(@site)
	  @wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = @wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 @browser.find_element(:id,"Email").send_keys("usu0100")
		 @browser.find_element(:id,"Passwd").send_keys("sytw20142015")
		 @browser.find_element(:id,"signIn").click
		 if (ARGV[0].to_s == "local")
			@browser.manage.timeouts.implicit_wait = 6
			@browser.find_element(:id,"submit_approve_access").send_keys:return
		 end
	  end
   end
   
   after :all do
	  @browser.quit
   end

   it "I can access user/index" do
	 begin
		element = @wait.until { @browser.find_element(:id,"usu") }
	 ensure
		element = element.text.to_s
		assert_equal(true, element.include?("USU DE PRUEBA"))
	 end
   end

   it "Button Logout works right" do
	 begin
		element = @wait.until { @browser.find_element(:id,"out") }
	 ensure
		element.click
		@browser.manage.timeouts.implicit_wait = 5
		 if (ARGV[0].to_s == "local")
			@site = "http://"+@site
		 end
		assert_equal(@site,@browser.current_url)
	 end
   end

   it "Button CloseSession works right" do
	  begin
		 element = @wait.until { @browser.find_element(:id,"close") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 assert_equal("https://accounts.google.com/ServiceLogin?elo=1",@browser.current_url)
	  end
   end  
end


# ******************************************************************
describe "Test APP Estadisticas Urls Cortas: Gestión de la BBDD" do

   before :all do
	  @browser = Selenium::WebDriver.for :firefox
	  @site = 'http://sytw5.herokuapp.com/'
	  if (ARGV[0].to_s == "local")
		 @site = 'localhost:9292/'
	  end
	  @browser.get(@site)
	  @wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
	  begin
		 element = @wait.until { @browser.find_element(:id,"enter") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 @browser.find_element(:id,"Email").send_keys("usu0100")
		 @browser.find_element(:id,"Passwd").send_keys("sytw20142015")
		 @browser.find_element(:id,"signIn").click
		 if (ARGV[0].to_s == "local")
			@browser.manage.timeouts.implicit_wait = 6
			@browser.find_element(:id,"submit_approve_access").send_keys:return
		 end
		 @browser.manage.timeouts.implicit_wait = 5
	  end
   end
   
   after :all do
	  @browser.get(@site+'user/index')
	  @browser.manage.timeouts.implicit_wait = 5
	  @browser.find_element(:id,"deleteall").click
	  @browser.quit
   end

   it "Create a new shorted url & check it" do
	  @browser.find_element(:id,"myurl").send_keys("http://www.ull.es/")
	  @browser.find_element(:id,"mylabel").send_keys("ull")
	  @browser.find_element(:id,"makeit").click
	  begin
		 element = @wait.until { @browser.find_element(:id,"mylabelgo") }
	  ensure
		 element.click
		 @browser.manage.timeouts.implicit_wait = 5
		 assert_equal("http://www.ull.es/",@browser.current_url)
	  end
   end

   it "New shorted url is displayed on the list" do
	  @browser.find_element(:id,"myurl").send_keys("http://www.ull.es/")
	  @browser.find_element(:id,"mylabel").send_keys("ull")
	  @browser.find_element(:id,"makeit").click
	  @browser.manage.timeouts.implicit_wait = 5
	  element = @browser.find_element(:id,"mylinks").find_element(:xpath,'.//*[contains(.,"ull")]').text
	  assert_equal("http://www.ull.es/ (ull)\nBorrar",element)
   end

   it "Check shorted url link by label" do
	  @browser.find_element(:id,"myurl").send_keys("http://www.ull.es/")
	  @browser.find_element(:id,"mylabel").send_keys("ull")
	  @browser.find_element(:id,"makeit").click
	  @browser.manage.timeouts.implicit_wait = 5
	  @browser.get(@browser.current_url+"/ull")
	  @browser.manage.timeouts.implicit_wait = 5
	  assert_equal("http://www.ull.es/",@browser.current_url)
   end
   
   it "Check shorted url link by id" do
	  @browser.find_element(:id,"myurl").send_keys("http://www.ull.es/view/centros/etsii/Inicio/es")
	  @browser.find_element(:id,"makeit").click #ahora lo creamos sin label para usar el id generado automaticamente
	  r = @browser.find_element(:id,"mylinks").find_element(:xpath,'.//*[contains(.,"etsii")]').text
	  a=[]
	  i = (r.size - (")\nBorrar".size)-1).to_i
	  while r[i]!="("
		 a << r[i]
		 i = i-1
	  end
	  r=0
	  for i in(0..a.size-1)
		 r = a[i].to_i * (10**i) + r
	  end
	  @browser.get(@browser.current_url+"/#{r}")
	  assert_equal("http://www.ull.es/view/centros/etsii/Inicio/es",@browser.current_url)
   end

   it "Delete all short url list" do
	  @browser.find_element(:id,"deleteall").click
	  @browser.manage.timeouts.implicit_wait = 5
	  assert_equal("EMPTY LIST",@browser.find_element(:id,"empty").text)
   end
   
   it "Delete a shorted url" do
	  @browser.find_element(:id,"myurl").send_keys("https://www.google.com/")
	  @browser.find_element(:id,"makeit").click
	  @browser.manage.timeouts.implicit_wait = 5
	  @browser.find_element(:id,"delete").click
	  @browser.manage.timeouts.implicit_wait = 5
	  assert_equal("EMPTY LIST",@browser.find_element(:id,"empty").text)
   end

end
