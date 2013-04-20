class AnswersController < ApplicationController
  before_filter :authenticate_user!
  def create 
    @answer = current_user.answers.new params[:answer]
    if @answer.save
      redirect_to @answer.question
    else
      flash[:error] = @answer.errors.full_messages.to_sentence
      redirect_to @answer.question
    end 
  end
end
