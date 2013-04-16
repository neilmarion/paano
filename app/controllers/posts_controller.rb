class PostsController < ApplicationController
  layout 'home', only: :index
  before_filter :authenticate_user!, except: [:index, :show]
  def index
    if params[:filter]
      case [:filter]

      when I18n.t('shared.home.left.unanswered') 
        Question.find_questions_without_an_answer.paginate params[:page]
      end
    elsif params[:query]
      @posts = Post.text_search(params[:query]).paginate params[:page]
    else
      @posts = Post.paginate params[:page]
    end
  end
end
