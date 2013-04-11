class PostsController < ApplicationController
  layout 'home', only: :index
  before_filter :authenticate_user!, except: [:index, :show]
  def index
    @posts = Post.text_search(params[:query]).page(params[:page]).per(PAGINATION['posts_index'])
  end
end
