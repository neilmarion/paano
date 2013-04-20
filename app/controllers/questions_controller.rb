class QuestionsController < ApplicationController
  layout 'home', only: [:show, :index, :mine, :unanswered, :new]
  before_filter :authenticate_user!, except: [:show, :index, :unanswered]

  def index

  end

  def mine
    @questions = current_user.questions.paginate params[:page]
    render :index
  end

  def unanswered
    @questions = Question.find_questions_without_an_answer.paginate params[:page]
    render :index
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
