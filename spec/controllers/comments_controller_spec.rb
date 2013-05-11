require 'spec_helper'

describe CommentsController do
  describe 'destroy' do
    before(:each) do
      question = FactoryGirl.create(:question)
      @answer = FactoryGirl.create(:answer, question: question)
      @comment = FactoryGirl.create(:comment, post: @answer)
    end

    it "will destroy it and the associated records" do
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
end
