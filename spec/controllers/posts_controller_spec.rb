require 'spec_helper'

describe PostsController do

  describe "GET 'index'" do
    before(:each) do
      @posts = []
      questions.each do |question|
        @posts << FactoryGirl.create(:question, title: question['title'], content: question['content'])
      end

      answers.each do |answer| 
        @posts << FactoryGirl.create(:answer, content: answer['content'])
      end

      @user_1 = FactoryGirl.create(:user_facebook)
    end
  
    it "returns http success" do
      Benchmark.realtime{
        get 'index'
      }.should < 1 
      response.should be_success
    end

    it "returns all search results" do
      get :index
      assigns(:posts).count.should eq @posts.count 
    end

    it "returns all posts if query is blank" do
      get :index, {query: ""}
      assigns(:posts).count.should eq @posts.count 
    end

    it "returns no search results" do
      get :index, { query: "bulabudakimbristitur" }
      assigns(:posts).should eq []
    end

    it "returns (plainly) by significance (ts_rank)" do
      get :index, { query: "hiccup" }
      assigns(:posts).should eq [@posts[7], @posts[27]]
    end

    it "returns (plainly) by reputation values" do
      question = FactoryGirl.create(:question, title: @posts[1].title, content: @posts[1].content)
      question.add_evaluation(:votes, 10, @user_1)
      get :index, { query: "fingerprint" }
      assigns(:posts).should eq [question, @posts[1], @posts[21]]
    end
    
  end

  describe 'GET new' do
    describe "success" do
      it "goes to posts/new" do
        get :new  
        response.should be_success
      end
    end

    describe "fail" do 
      describe "while user not signed in" do
        before(:each) do
          sign_in FactoryGirl.create(:user_facebook)
        end

        it "unsucessfully goes to posts/new" do 
          #stub_request(:get, new_question_path).to_return(:status => [500, "Internal Server Error"])
          get :new
          request.should redirect_to new_session_path
          #correct handling of exceptions
          pending
        end
      end
    end
  end

  describe 'POST create' do
    before(:each) do
      @params = {"question" => {"title" => "Question Title", "content" => "Question Content", "tags" => {"0" => "question_tag"}}}
    end

    describe "success" do
      before(:each) do
        sign_in FactoryGirl.create(:user_facebook)
      end
    
      it "creates a new question" do
        post :create, @params
      end
    end

    describe "fail" do
      describe "while user signed it" do
        it "does not create a question if it does not have a title" do
          @params['question']['title'] = ""
          post :create, @params
          request.should render_template("new")
        end

        it "does nto create a question if it does not have a content" do
          @params['question']['content'] = ""
          post :create, @params
          request.should render_template("new")
        end
        
        it "does not create a question if it does not have tags" do
          @params['question']['tags'] = ""
          post :create, @params
          request.should render_template("new")
        end
      end

      describe "while user is not signed in" do
        it "does not create a question if a user is not signed in" do
          post :create, {"question" => {"title" => "Question title", "content" => "Question Content"}}
          request.should redirect_to new_session_path
        end
      end
    end
  end
end

def questions 
  file = File.read(
    File.expand_path('../../factories/test_questions_data.json', __FILE__))
  ActiveSupport::JSON.decode(file)
end

def answers 
  file = File.read(
    File.expand_path('../../factories/test_answers_data.json', __FILE__))
  ActiveSupport::JSON.decode(file)
end
