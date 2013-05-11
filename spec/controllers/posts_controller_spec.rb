require 'spec_helper'

describe PostsController do
  include_context "common controller stuff"
  
  describe "index" do
    let!(:user_1){ FactoryGirl.build(:user_facebook) }

    it "returns all search results in desc chronological order" do
      #funny mock test. Will be returning back here soon. 
      post = FactoryGirl.create(:question)
      get :index
      response.should redirect_to recent_posts_path
    end

    describe "full-text search" do
      before(:each) do
        @query = "Magnanimous"
        word = "Other"
        @jiberish = "xxx"
        @post_1 = FactoryGirl.create(:question_with_an_answer, title: @query, content: @query, tag_list: @query)         
        @post_2 = FactoryGirl.create(:question_with_an_answer, title: word, content: @query, tag_list: @query)
        @post_3 = FactoryGirl.create(:question_with_an_answer, title: @query, content: @query, tag_list: @query)
      end

      it "returns all posts in desc chronological order if query is blank" do
        get :index, {query: ""}
        response.should redirect_to recent_posts_path
      end

      it "returns no search results" do
        get :index, { query: @jiberish }
        assigns(:posts).should eq []
      end

      it "returns (plainly) by significance (ts_rank)" do
        Post.destroy(@post_1.id)
        get :index, { query: @query }
        assigns(:posts).should eq [@post_3, @post_2]
      end

      it "returns (plainly) by reputation values" do
        Post.destroy(@post_2.id)
        @post_1.add_evaluation(:question_reputation, 10, user_1)
        get :index, { query: @query }
        assigns(:posts).should eq [@post_1, @post_3]
      end
    end
  end

  describe "filtering posts" do
    it "returns all the top posts" do
      title = "title"
      content = "title"
      tag_list = "tag"
      @post_1 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
      @post_2 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
      @post_2.add_evaluation(:question_reputation, 10, FactoryGirl.create(:user_facebook))

      xhr :get, :top
      assigns(:posts).should eq [@post_2, @post_1]
    end
  end

  describe "comment" do #authentication whether or not user can comment or not on a post
    it 'fails if user is not logged in' do
      xhr :get, :comment, {format: :json}
      should_be_unauthorized_access
    end 

    it 'succeeds if user is logged in' do
      user = FactoryGirl.create(:user_facebook)
      sign_in user    
      xhr :get, :comment, {format: :json}
      response.should be_success
    end
  end

  describe "recent" do
    it 'returns all the posts from the most recent to the oldest' do
      post_1 = FactoryGirl.create(:question, title: 'title', content: 'content', tag_list: 'tag_list')
      post_2 = FactoryGirl.create(:question, title: 'title', content: 'content', tag_list: 'tag_list')
      
      xhr :get, :recent
      assigns(:posts).should eq [post_2, post_1]
    end
  end
end
