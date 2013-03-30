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

def posts
  file = File.read(
    File.expand_path('../../factories/test_data.json', __FILE__))
  ActiveSupport::JSON.decode(file)
end
