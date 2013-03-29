class PostsController < ApplicationController
  #before_filter :authenticate_user!, except: [:index, :show]
  def index
    @posts = Post.all
  end
  
  def new

  end
end
