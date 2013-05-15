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
      redirect_to question_path @question 
    else
      flash[:error] = @question.errors.full_messages.to_sentence
      render :new, :layout => 'home'  
    end 
  end

  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.json { render :json => {name: current_user.name } }
        format.html { redirect_to(@question,
          :notice => I18n.t('questions.notice')) }
      else
        format.json { render :json => @question.errors.full_messages.to_sentence }
        format.html { flash[:error] = @question.errors.full_messages.to_sentence
          redirect_to @question }
      end
    end
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find params[:id]
  end

  def answer #validator whether user is able to answer or not
    render :json => {}
  end

  def vote_up
    @question = Question.find params[:id]
    respond_to do |format|
      if @question.add_evaluation(:question_reputation, SCORING['up'], current_user)
        format.json { render :json => {votes: @question.vote_count} }
      else
        format.json { render :json => @question.errors.full_messages.to_sentence }
      end 
    end 
  end 

  def vote_down
    @question = Question.find params[:id]
    respond_to do |format|
      if @question.add_evaluation(:question_reputation, SCORING['down'], current_user) 
        format.json { render :json => {votes: @question.vote_count} }
      else
        format.json { render :json => @question.errors.full_messages.to_sentence }
      end 
    end 
  end

  def destroy
    @question = Question.find(params[:id]) 
    if @question.destroy
      redirect_to mine_questions_path
    else
      render :show
    end 
  end
end
