require 'sinatra/base'
require 'sinatra/activerecord'
require './config/environments'

class Post < ActiveRecord::Base
end

# nodoc
class App < Sinatra::Base
  get '/' do
    'Hello, world!'
  end
end

