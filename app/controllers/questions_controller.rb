class QuestionsController < ApplicationController
  def index
  end

  def create 
    @question = User.find(session[:user_id]).questions.new(params[:question])
    if @question.save
      redirect_to :questions
    else
      render :new      
    end 
  end

  def new

  end
end
