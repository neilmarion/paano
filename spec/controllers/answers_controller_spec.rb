require 'spec_helper'

describe AnswersController do
  include_context "common controller stuff"
  
  before(:each) do
    @question = FactoryGirl.create(:question)
  end

  describe 'create' do
    it 'fails if user is not signed in' do
      expect{
        xhr :post, :create, {:answer => {:content => "My Answer", :user_id => nil, :question_id => @question.id}}
        should_be_unauthorized_access
      }.to_not change(Answer, :count)
    end

    it 'succeeds if user is signed in' do
      user = sign_in_user
      expect{ 
        xhr :post, :create, {:answer => {:content => "My Answer", :user_id => user.id, :question_id => @question.id}}
      }.to change(Answer, :count)
    end
  end
end
