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
      sign_in_user
    end 
  
    it_behaves_like "a user voted on a post"
  end
end
