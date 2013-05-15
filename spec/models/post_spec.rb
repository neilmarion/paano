require 'spec_helper'

describe Post do
  it { should belong_to :user }
  it { should have_many :comments }

  describe 'text_search' do
    let(:post){ FactoryGirl.create(:question) }
    it 'returns results' do
      Post.text_search(post.title).should eq [post]
    end

    it 'returns no results' do
      Post.text_search("xxx").should eq []
    end

    it 'should not return comments' do
      comment = FactoryGirl.create(:comment)
      Post.text_search(comment.content).should_not eq [comment]
    end

    describe 'query not present' do
      it 'returns all results' do
        comment = FactoryGirl.create(:comment)
        Post.text_search(nil).should eq [post]
      end
    end
  end

  describe 'finding top posts' do
    before(:each) do
      title = "title"
      content = "title"
      tag_list = "tag"
      @post_1 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
      @post_2 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
      @post_2.add_evaluation(:question_reputation, 10, FactoryGirl.create(:user_facebook))
    end

    it 'finds posts ordered by highest reputation at descending order' do
      Post.find_top_posts.should eq [@post_2, @post_1]
    end

    it 'does not include comments' do
      FactoryGirl.create(:comment)
      Post.find_top_posts.should eq [@post_2, @post_1]
    end
  end

  describe 'destroy' do
    before(:each) do
      @question = FactoryGirl.create(:question) 
      @answer = FactoryGirl.create(:answer, question: @question)
      @comment = FactoryGirl.create(:comment, post: @answer)
    end

    it "destroys the activerecord and all the related records" do
      expect{
        expect{
          expect{
            expect{
              expect{
                expect{
                  @question.destroy
                }.to change(Question, :count).by -1
              }.to change(Answer, :count).by -1
            }.to change(Comment, :count).by -1
          }.to_not change(Question.with_deleted, :count)
        }.to_not change(Answer.with_deleted, :count)
      }.to_not change(Comment.with_deleted, :count)
    end
  end

  describe 'a user votes' do
    before(:each) do
      @user1 = FactoryGirl.create(:user_facebook)
      @user2 = FactoryGirl.create(:user_facebook)
      @question = FactoryGirl.create(:question, user: @user1)
    end

    it 'up' do
      expect{
        @question.vote_up(@user2)
      }.to change(@question, :reputation).by SCORING['up']
    end

    it 'down' do
      expect{
        @question.vote_down(@user2)
      }.to change(@question, :reputation).by SCORING['down']
    end

    describe 'but should not be able to vote own post' do
      it 'votes up' do
        expect{
          expect{
            @question.vote_up(@user1)
          }.to raise_error
        }.to_not change(@question, :reputation)
      end

      it 'votes down' do
        expect{
          expect {
            @question.vote_down(@user1)
          }.to raise_error
        }.to_not change(@question, :reputation)
      end
    end
  end
end
