class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    @comment = Comment.find(params[:id]) 
    if @comment.destroy
      head :no_content
    else
      render :json => {error: I18n.t('.comments.errors.destroy')}
    end
  end
end
