require 'spec_helper'

describe PostsController do

  describe "GET 'index'" do
    before(:each) do
      @question_1 = FactoryGirl.create(:question, content: "Question Exactly Michael Jackson")
      @question_2 = FactoryGirl.create(:question)
      @question_3 = FactoryGirl.create(:question, content: "Question Exact This is")

      @user_1 = FactoryGirl.create(:user_facebook)
      
      @question_1.add_evaluation(:votes, 15, @user_1)
    end
  
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns search results" do
      get :index, { query: "Question" }
      assigns(:posts).should eq [@question_1, @question_2, @question_3]
    end

    it "returns exact search results" do
      get :index, { query: "Exactly Michael Jackson" }
      assigns(:posts).should eq [@question_1]
    end

    it "returns results according to reputation * relevance scores" do
      get :index, { query: "Question Exact" } 
      assigns(:posts).should eq [@question_1, @question_3]
    end

  end

end
