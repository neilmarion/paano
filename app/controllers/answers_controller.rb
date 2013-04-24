class AnswersController < ApplicationController
  before_filter :authenticate_user!

  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.json { render :json => {name: current_user.name } }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence } #output javascript messages
      end
    end
  end
end
