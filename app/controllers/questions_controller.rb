class QuestionsController < ApplicationController
  layout 'home', only: [:show, :index]
  before_filter :authenticate_user!, except: [:show]

  def index
    @questions = Question.find_questions_without_an_answer
  end

  def create 
    @question = User.find(current_user.id).questions.new params[:question]
    if @question.save
      redirect_to :posts
    else
      flash[:error] = @question.errors.full_messages.to_sentence
      render :new 
    end 
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find params[:id]
  end

end
