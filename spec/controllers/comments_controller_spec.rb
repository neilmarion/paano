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
          xhr :post, :destroy, {id: @comment.id}
        }.to change(Comment, :count).by -1
      end

      it "will fail to destroy the record" do
        Comment.any_instance.should_receive(:destroy).and_return false
        expect{
          xhr :post, :destroy, {id: @comment.id}
        }.to_not change(Comment, :count)
      end
    end

    describe "user not signed in" do
      it "will fail to destroy the record" do
        expect{
          xhr :post, :destroy, {id: @comment.id}
        }.to_not change(Comment, :count)
        should_be_unauthorized_access 
      end
    end
  end
end
