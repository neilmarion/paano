class PostsController < ApplicationController
  layout 'home', only: [:index, :top]
  before_filter :authenticate_user!, except: [:index, :show, :top]

  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag' 

  def index
    @posts = Post.text_search(params[:query]).paginate params[:page]
  end

  def top
    @posts = Post.find_top_posts.paginate params[:page]
    render :index
  end
end
