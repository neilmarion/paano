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
end
