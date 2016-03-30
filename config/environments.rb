require 'sinatra'
require 'yaml'

configure :development do 
 database = YAML.load_file("./config/database.yml")  
 environment = ENV["RACK_ENV"] || "development"
   
 ActiveRecord::Base.establish_connection(
   :adapter  => database.fetch(environment)['adapter'],
   :host     => database.fetch(environment)['hostname'],
   :username => database.fetch(environment)['username'],
   :password => database.fetch(environment)['password'],
   :database => database.fetch(environment)['database'],
   :encoding => database.fetch(environment)['encoding']
 )
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end
