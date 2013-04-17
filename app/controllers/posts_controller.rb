class PostsController < ApplicationController
  layout 'home', only: :index
  before_filter :authenticate_user!, except: [:index, :show]
  def index
    if params[:filter]
      case params[:filter]
      when I18n.t('shared.home.left.top')
        @posts = Post.find_top_posts.paginate params[:page]
      end
    else
      @posts = Post.text_search(params[:query]).paginate params[:page]
    end 
  end
end
