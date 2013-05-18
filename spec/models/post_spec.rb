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
      @user = FactoryGirl.create(:user_facebook)
      @question = FactoryGirl.create(:question, user: @user) 
      @answer = FactoryGirl.create(:answer, question: @question, user: @user)
      @comment = FactoryGirl.create(:comment, post: @answer, user: @user)
    end

    describe "destroys the activerecord and all the related records" do
      it "of a question" do
        bef_reputation = @user.karma
        @question.vote_up(FactoryGirl.create(:user_facebook))
        aft_reputation = @user.karma

        expect{
          expect{
            expect{
              expect{
                expect{
                  expect{
                    expect{
                    @question.destroy
                    }.to change(@user, :karma).by bef_reputation - aft_reputation
                  }.to change(Question, :count).by -1
                }.to change(Answer, :count).by -1
              }.to change(Comment, :count).by -1
            }.to_not change(Question.with_deleted, :count)
          }.to_not change(Answer.with_deleted, :count)
        }.to_not change(Comment.with_deleted, :count)
      end

      it "of an answer" do
        bef_reputation = @user.karma
        @answer.vote_up(FactoryGirl.create(:user_facebook))
        aft_reputation = @user.karma

        expect{
          expect{
            expect{
              expect{
                expect{
                  expect{
                    expect{
                      @answer.destroy
                    }.to change(@user, :karma).by bef_reputation - aft_reputation
                  }.to_not change(Question, :count)
                }.to change(Answer, :count).by -1
              }.to change(Comment, :count).by -1
            }.to_not change(Question.with_deleted, :count)
          }.to_not change(Answer.with_deleted, :count)
        }.to_not change(Comment.with_deleted, :count)
      end
    end
  end

  describe 'voting' do
    before(:each) do
      @user1 = FactoryGirl.create(:user_facebook)
      @user2 = FactoryGirl.create(:user_facebook)
      @question = FactoryGirl.create(:question, user: @user1)
    end

    describe 'on a question' do
      it 'up' do
        expect{
          @question.vote_up(@user2)
        }.to change(@question, :reputation).by SCORING['question_up']
      end

      it 'down' do
        expect{
          @question.vote_down(@user2)
        }.to change(@question, :reputation).by SCORING['down']
      end
    end

    describe 'on an answer' do
      before(:each) do
        @answer = FactoryGirl.create(:answer, question: @question, user: @user1)
      end

      it 'up' do
        expect{
          @answer.vote_up(@user2)
        }.to change(@answer, :reputation).by SCORING['up']
      end

      it 'down' do
        expect{
          @answer.vote_down(@user2)
        }.to change(@answer, :reputation).by SCORING['down']
      end
    end

    describe 'but should not be able to vote own post' do
      before(:each) do
        @answer = FactoryGirl.create(:answer, user: @user1, question: @question)
      end

      it 'votes up' do
        expect{
          expect{
            @answer.vote_up(@user1)
          }.to raise_error
        }.to_not change(@answer, :reputation)
      end

      it 'votes down' do
        expect{
          expect {
            @answer.vote_down(@user1)
          }.to raise_error
        }.to_not change(@answer, :reputation)
      end
    end

    describe 'unvoting' do
      describe 'unvotes' do
        it 'on question' do
          bef_reputation = @question.reputation
          @question.vote_up(@user2)
          aft_reputation = @question.reputation
          
          expect {
            expect {
              @question.unvote(@user2)
            }.to change(@question, :reputation).by bef_reputation - aft_reputation
          }.to change(@user1, :karma).by bef_reputation - aft_reputation

          #votes again
          expect {
            @question.vote_up(@user2)
          }.to change(@question, :reputation).by SCORING['question_up']
        end

        it 'on answer' do
          @answer = FactoryGirl.create(:answer, user: @user1, question: @question)
          bef_reputation = @answer.reputation
          @answer.vote_up(@user2)
          aft_reputation = @answer.reputation
          
          expect {
            expect {
              @answer.unvote(@user2)
            }.to change(@answer, :reputation).by bef_reputation - aft_reputation
          }.to change(@user1, :karma).by bef_reputation - aft_reputation

          #votes again
          expect {
            @answer.vote_up(@user2)
          }.to change(@answer, :reputation).by SCORING['up']
        end
      end
    end
  end
end
