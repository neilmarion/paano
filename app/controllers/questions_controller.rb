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
    remove_blank_answer_param if params[:question][:answers_attributes]
    @question = User.find(current_user.id).questions.new params[:question]
    if @question.save
      redirect_to :posts
    else
      flash[:error] = @question.errors.full_messages.to_sentence
      render :new, :layout => 'home'  
    end 
  end

  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html  { redirect_to(@question,
                      :notice => I18n.t('questions.notice')) }
      else
        format.html  { render :show }
      end
    end
  end

  def new
    @question = Question.new
    @question.answers.new
  end

  def show
    @question = Question.find params[:id]
  end

  private

  def remove_blank_answer_param #this happens during question create
    params[:question].delete(:answers_attributes) if params[:question][:answers_attributes]['0'][:content].blank?
  end
end
