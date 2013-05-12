require 'spec_helper'

describe AnswersController do
  include_context "common controller stuff"

  describe "update" do
    before(:each) do
      @post = FactoryGirl.create(:answer, question: FactoryGirl.create(:question))
      @post_key = :answer
      @post_of_post_attributes_key = :comments_attributes
    end 

    it_behaves_like "a user posted on a post" 
  end

  describe 'voting' do
    before(:each) do
      question = FactoryGirl.create(:question) 
      @post = FactoryGirl.create(:answer, question: question)
      @params = {id: @post.id}
      @model_class = Answer
      @rep_name = :answer_reputation
      sign_in_user
    end 
  
    it_behaves_like "a user voted on a post"
  end

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

      it "will destroy it and the associated records" do
        expect{
          expect{
            expect{
              expect{
                xhr :post, :destroy, {id: @answer.id}  
              }.to change(Answer, :count).by -1
            }.to change(Comment, :count).by -1
          }.to_not change(Answer.with_deleted, :count)
        }.to_not change(Comment.with_deleted, :count)
      end

      it "will fail to destroy the record" do
        Answer.any_instance.should_receive(:destroy).and_return false
        expect{
          expect{
            xhr :post, :destroy, {id: @answer.id}  
          }.to_not change(Answer, :count)
        }.to_not change(Comment, :count)
      end
    end

    describe "user not signed in" do
      before(:each) do
        @post = @anwer
        @model_class = @post.class
      end

      it_behaves_like "a user not signed in attempted to delete a post"
    end
  end
end
