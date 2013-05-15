class PostsController < ApplicationController
  layout 'home', only: [:index, :top, :recent]
  before_filter :authenticate_user!, except: [:index, :show, :top, :recent]

  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag' 

  def index
    unless params[:query].blank?
      @posts = Post.text_search(params[:query]).paginate params[:page]
    else
      redirect_to recent_posts_path 
    end
  end

  def top
    @posts = Post.find_top_posts.paginate params[:page]
    render :index
  end

  def recent
    @posts = Post.where_post_is_not_a_comment.order('created_at DESC').paginate params[:page]
    render :index
  end

  def comment #validator whether user is able to comment or not
    render :json => {}
  end

  def unvote
    post = Post.find(params[:id])
    if post.unvote(current_user)
      render :json => {votes: post.vote_count, id: post.id}
    else
      render :json => post.errors.full_messages.to_sentence 
    end
  end
end
