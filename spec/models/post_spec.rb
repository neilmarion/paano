require 'spec_helper'

describe Post do
  it { should belong_to :user }

  describe 'text_search' do
    describe 'success' do
      let(:post){ FactoryGirl.create(:question) }
      it 'returns results' do
        Post.text_search(post.title).should eq [post]
      end

      it 'returns no results' do
        Post.text_search("xxx").should eq []
      end
  
      describe 'query not present' do
        it 'returns all results' do
          Post.text_search(nil).should eq [post]
        end
      end
    end
  end

  describe 'finding top posts' do
    before(:each) do
      title = "title"
      content = "title"
      tag_list = "tag"
      @post_1 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
      @post_2 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list).
        add_evaluation(:votes, 10, FactoryGirl.create(:user_facebook))
    end

    it 'finds posts ordered by highest reputation at descending order' do
      Post.find_top_posts 
    end
  end
end
