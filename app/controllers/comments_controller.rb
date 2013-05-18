class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @comment = User.find(current_user.id).comments.new params[:comment]

    respond_to do |format|
      if @comment.save
        format.json { render :json => {id: current_user.id, name: current_user.name} } 
      else
        format.json { render :json => @comment.errors.full_messages.to_sentence } #output javascript messages
      end   
    end
  end

  def destroy
    @comment = Comment.find(params[:id]) 
    if @comment.destroy
      head :no_content
    else
      render :json => {error: I18n.t('.comments.errors.destroy')}
    end
  end
end
