class PostsController < ApplicationController
  layout 'home', only: :index
  before_filter :authenticate_user!, except: [:index, :show]
  def index
    @posts = Post.text_search(params[:query]).paginate params[:page]
  end
end
