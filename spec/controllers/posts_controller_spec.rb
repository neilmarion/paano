require 'spec_helper'

describe PostsController do
  describe "index" do
    let!(:user_1){ FactoryGirl.build(:user_facebook) }

    it "returns all search results" do
      #funny mock test. Will be returning back here soon. 
      post = FactoryGirl.create(:question)
      get :index
      assigns(:posts).should eq [post]
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

      it "returns all posts if query is blank" do
        get :index, {query: ""}
        assigns(:posts).count.should eq Post.count 
      end

      it "returns no search results" do
        get :index, { query: @jiberish }
        assigns(:posts).should eq []
      end

      it "returns (plainly) by significance (ts_rank)" do
        get :index, { query: @query }
        assigns(:posts).should eq [@post_1, @post_3, @post_2]
      end

      it "returns (plainly) by reputation values" do
        Post.destroy(@post_2.id)
        @post_1.add_evaluation(:votes, 10, user_1)
        get :index, { query: @query }
        assigns(:posts).should eq [@post_1, @post_3]
      end
    end

    describe "filtering posts" do
      it "returns all the top posts" do
        title = "title"
        content = "title"
        tag_list = "tag"
        @post_1 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
        @post_2 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list).
          add_evaluation(:votes, 10, FactoryGirl.create(:user_facebook))

        get :index, {filter: 'top'} 
        assigns(:posts).should eq [@post_2, @post_1]
      end
    end
  end
end
