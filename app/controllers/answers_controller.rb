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
        helper = ActionController::Base.helpers
        format.json { render :json => {name: current_user.name, content: helper.raw(helper.sanitize(helper.simple_format(@answer.content), :tags => %w(br p))) } }
        format.html { redirect_to @answer.question }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence } #output javascript messages
        format.html { redirect_to @answer.question }
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
