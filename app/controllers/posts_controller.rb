class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  def index
    @posts = Post.text_search(params[:query])
  end
  
  def new

  end
end
