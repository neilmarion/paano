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
end
