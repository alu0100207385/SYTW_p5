task :default => :tests

desc "Run the server via Sinatra"
task :sinatra do
  sh "ruby app.rb"
end

desc "Run the server via rackup"
task :rackup do
  sh "rackup"
end

desc "Update app in Heroku"
task :update do
  sh "git checkout master"
  sh "git commit -a -m 'update config heroku'"
  sh "git push origin master"
  sh "git push heroku master"
end

desc "Open app in Heroku"
task :heroku do
#    sh "heroku pg:reset DATABASE_URL --confirm sytw5"
#    sh "heroku run rake db:migrate"
   sh "heroku open"
end

desc "Run tests (default)"
task :tests do
#    sh "heroku pg:reset DATABASE_URL --confirm sytw5"
#    sh "heroku run rake db:migrate"
#    sh "rm my_shortened_urls.db"
   sh "ruby test/test.rb"
end

desc "Run tests in local machine"
task :local_tests do
   sh "gnome-terminal -x sh -c 'rackup' && sh -c 'ruby test/test.rb local'"
end

desc "Open repository"
task :repo do
  sh "gnome-open https://github.com/alu0100207385/SYTW_p5"
end

