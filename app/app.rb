require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require './config/environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

 enable :sessions

class Post < ActiveRecord::Base
 validates :title, presence: true, length: { minimum: 5 }
 validates :body, presence: true
end

puts "hello"

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

puts "goodbye"

# nodoc
class App < Sinatra::Base
 
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash 
 
  enable :sessions
 
  get '/' do
    @posts = Post.order("created_at DESC")
    @title = "Welcome."
    erb :"posts/index"
  end

  get "/posts/create" do
    @title = "Create post"
    @post = Post.new
    erb :"posts/create"
  end

  post "/posts" do
    @post = Post.new(params[:post])
    if @post.save
      redirect "posts/#{@post.id}", :notice => 'Congrats! New favorite added. (This message will vanish in 4 seconds.)'
    else
      redirect "posts/create", :error => 'Something went wrong. Title and Body must not be empty. (This message will vanish in 4 seconds.)'
    end
  end

  get "/posts/:id" do
    @post = Post.find(params[:id])
    @title = @post.title
    erb :"posts/view"
  end

end
