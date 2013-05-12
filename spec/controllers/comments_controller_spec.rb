require 'spec_helper'

describe CommentsController do
  include_context "common controller stuff"

  describe 'destroy' do
    before(:each) do
      question = FactoryGirl.create(:question)
      @answer = FactoryGirl.create(:answer, question: question)
      @comment = FactoryGirl.create(:comment, post: @answer)
    end

    describe "user signed in" do
      before(:each) do
        sign_in_user
      end

      it "will destroy the record" do
        expect{
          expect{
            xhr :post, :destroy, {id: @comment.id}
          }.to change(Comment, :count).by -1
        }.to_not change(Comment.with_deleted, :count)
      end

      it "will fail to destroy the record" do
        Comment.any_instance.should_receive(:destroy).and_return false
        expect{
          xhr :post, :destroy, {id: @comment.id}
        }.to_not change(Comment, :count)
      end
    end

    describe "user not signed in" do
      before(:each) do
        @post = @comment
        @model_class = @post.class
      end
  
      it_behaves_like "a user not signed in attempted to delete a post"
    end
  end
end
