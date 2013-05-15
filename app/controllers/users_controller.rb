class UsersController < ApplicationController
  layout 'home' 
  def index

  end
  
  def top
    @users = User.top.paginate params[:page]
    render :index
  end

  def recent 
    @users = User.recent.paginate params[:page]
    render :index
  end

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.paginate params[:page]
  end
end
