require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require './config/environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'rss'

class Post < ActiveRecord::Base
 validates :title, presence: true, length: { minimum: 5 }
 validates :body, presence: true
end

# nodoc
class App < Sinatra::Base
 
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash 

  #allow for sessions to save state in a client-local cookie 
  enable :sessions

  #enable modular application to actually send delete and put requests in browsers that don't understand these REST methods
  enable :method_override
  
  helpers do
    def title
      if @title
        "#{@title}"
      else
        "Welcome."
      end
    end
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  module RssItems
    RSS_ITEMS = RSS::Parser.parse('https://news.ycombinator.com/rss', false)
  end

  # get all posts
  get '/' do
    @posts = Post.order("created_at DESC")
    @title = "Welcome."
    erb :"posts/index"
  end

  # create new post
  get "/posts/create" do
    @title = "Create post"
    @post = Post.new
    erb :"posts/create"
  end

  post "/posts" do
    @post = Post.new(params[:post])
    if @post.save
      redirect "/", :notice => 'Congrats! New favorite added. (This message will vanish in 4 seconds.)'
    else
      redirect "posts/create", :error => 'Something went wrong. Title and URL must both not be empty. (This message will vanish in 4 seconds.)'
    end
  end

  # view post
  get "/posts/:id" do
    @post = Post.find(params[:id])
    @title = @post.title
    erb :"posts/view"
  end

  # delete post
  get "/posts/:id/delete" do
    @post = Post.find(params[:id])
    @title = "Delete Form"
    erb :"posts/delete"
  end
 
  delete "/posts/:id" do
    @post = Post.delete(params[:id])
    redirect "/" 
  end

end
