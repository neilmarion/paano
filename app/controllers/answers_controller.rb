class AnswersController < ApplicationController
  before_filter :authenticate_user!

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      redirect_to(@answer,
        :notice => I18n.t('answer.notice'))
    else
      flash[:error] = @answer.errors.full_messages.to_sentence
      redirect_to @answer
    end 
  end
end
