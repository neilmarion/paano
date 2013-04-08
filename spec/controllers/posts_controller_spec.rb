require 'spec_helper'

describe PostsController do
  describe "index" do
    before(:all) do
     load_test_posts 
    end

    after(:all) do
      Post.destroy_all
    end

    let!(:user_1){ FactoryGirl.create(:user_facebook) }
  
    it "goes to index" do
      xhr :get, :index
    end

    it "returns all search results" do
      get :index
      assigns(:posts).count.should eq PAGINATION['posts_index'] 
    end

    it "returns all posts if query is blank" do
      get :index, {query: ""}
      assigns(:posts).count.should eq PAGINATION['posts_index'] 
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
      question.add_evaluation(:votes, 10, user_1)
      get :index, { query: "fingerprint" }
      assigns(:posts).should eq [question, @posts[1], @posts[21]]
    end
  end
end
