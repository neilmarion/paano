class AnswersController < ApplicationController
  before_filter :authenticate_user!

  def create
    @answer = User.find(current_user.id).answers.new params[:answer]
    if @answer.save
      redirect_to question_path(@answer.question)+"##{@answer.id}"
    else
      flash[:error] = @answer.errors.full_messages.to_sentence
      redirect_to question_path @answer.question 
    end 
  end

  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.json { render :json => {name: current_user.name, content: @answer.content } }
        format.html { redirect_to @answer.question }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence } #output javascript messages
        format.html { redirect_to @answer.question }
      end
    end
  end

  def vote_up
    @answer = Answer.find params[:id]
    respond_to do |format|
      if @answer.vote_up(current_user)
        format.json { render :json => {votes: @answer.vote_count} }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence }
      end
    end
  end

  def vote_down
    @answer = Answer.find params[:id]
    respond_to do |format|
      if @answer.vote_down(current_user)
        format.json { render :json => {votes: @answer.vote_count} }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id]) 
    if @answer.destroy
      head :no_content
    else
      render :json => {error: I18n.t('.comments.errors.destroy')}
    end 
  end
end
