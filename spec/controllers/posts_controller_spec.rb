require 'spec_helper'

describe PostsController do

  describe "GET 'index'" do
    before(:each) do
      @question_1 = FactoryGirl.create(:question)
      @question_2 = FactoryGirl.create(:question)
    end
  
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns search results" do
      get :index, { query: "Question 1" }
      assigns(:posts).should eq [@question_1]
    end
  end

end
