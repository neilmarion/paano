class PostsController < ApplicationController
  layout 'home', only: [:index, :top, :recent]
  before_filter :authenticate_user!, except: [:index, :show, :top, :recent]

  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag' 

  def index
    @posts = Post.text_search(params[:query]).paginate params[:page]
  end

  def top
    @posts = Post.find_top_posts.paginate params[:page]
    render :index
  end

  def recent
    @posts = Post.order('created_at DESC').paginate params[:page]
    render :index
  end

  def comment #validator whether user is able to comment or not
    render :json => {}
  end
end
