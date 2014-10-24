desc "run the http server"
task :default do
  sh "ruby app.rb"
end

=begin
desc "run the server via rackup"
task :rackup do
  sh "rackup"
end
=end

desc "Update app in Heroku"
task :update do
  sh "git commit -a -m 'update config heroku'"
  sh "git push origin master"
  sh "git push heroku master"
end

desc "Open app in Heroku"
task :heroku do
  sh "heroku open"
end

desc "Open repository"
task :repo do
  sh "gnome-open https://github.com/alu0100207385/SYTW_p5"
end

