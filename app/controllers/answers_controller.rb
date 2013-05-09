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

  def vote_up
    @answer = Answer.find params[:id]
    respond_to do |format|
      if @answer.add_evaluation(:answer_votes, SCORING['up'], current_user)
        format.json { render :json => {votes: @answer.reputation_for(:answer_votes).to_i} }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence }
      end
    end
  end

  def vote_down
    @answer = Answer.find params[:id]
    respond_to do |format|
      if @answer.add_evaluation(:answer_votes, SCORING['down'], current_user)
        format.json { render :json => {votes: @answer.reputation_for(:answer_votes).to_i} }
      else
        format.json { render :json => @answer.errors.full_messages.to_sentence }
      end
    end
  end
end
