require 'spec_helper'

describe PostsController do

  describe "GET 'index'" do
    before(:each) do
      @question_1 = FactoryGirl.create(:question, content: "Question Exact")
      @question_2 = FactoryGirl.create(:question)
    end
  
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns search results" do
      get :index, { query: "Question" }
      assigns(:posts).should eq [@question_1, @question_2]
    end

    it "returns exact search results" do
      get :index, { query: "Exact" }
      assigns(:posts).should eq [@question_1]
    end

  end

end
