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

  def vote_up
    @post = Post.find params[:id]
    respond_to do |format|
      if @post.add_evaluation(:votes, SCORING['up'], current_user) 
        format.json { render :json => "" }
      else
        format.json { render :json => @post.errors.full_messages.to_sentence }
      end
    end
  end

  def vote_down
    @post = Post.find params[:id]
    respond_to do |format|
      if @post.add_evaluation(:votes, SCORING['down'], current_user) 
        format.json { render :json => "" }
      else
        format.json { render :json => @post.errors.full_messages.to_sentence }
      end
    end
  end
end
