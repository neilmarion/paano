require 'spec_helper'

describe PostsController do

  describe "GET 'index'" do
    before(:each) do
      @questions = []
      posts.each do |post|
        @questions << FactoryGirl.create(:question, title: post['title'], content: post['content'])
      end
      @user_1 = FactoryGirl.create(:user_facebook)
    end
  
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns all search results" do
      get :index
      assigns(:posts).should eq @questions 
    end

    it "returns all search results if query is blank" do
      get :index, {query: ""}
      assigns(:posts).should eq @questions 
    end

    it "returns no search results" do
      get :index, { query: "bulabudakimbristitur" }
      assigns(:posts).should eq []
    end

    it "returns (plainly) by significance (ts_rank)" do
      get :index, { query: "water" }
      assigns(:posts).should eq [@questions[6], @questions[0], @questions[9]]
    end

    it "returns (plainly) by reputation values" do
      question = FactoryGirl.create(:question, title: @questions[1].title, content: @questions[1].content)
      question.add_evaluation(:votes, 3, @user_1)
      get :index, { query: "fingerprint" }
      assigns(:posts).should eq [question, @questions[1]]
    end
    
  end

end

def posts
  file = File.read(
    File.expand_path('../../factories/test_data.json', __FILE__))
  ActiveSupport::JSON.decode(file)
end
