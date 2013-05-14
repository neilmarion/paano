require 'spec_helper'

describe UsersController do
  include_context "common controller stuff"

  before(:each) do
    @user1 = FactoryGirl.create(:user_facebook)
    @user2 = FactoryGirl.create(:user_facebook)
  end

  describe "recent" do
    it "returns all users on descending order of created_by" do
      xhr :get, :recent
      assigns(:users).should eq [@user2, @user1]
    end
  end 

  describe "top" do
    it "returns all users on descending order of karma reputation" do
      question1 = FactoryGirl.create(:question, user: @user2)
      question2 = FactoryGirl.create(:question, user: @user1)

      question1.add_evaluation(:question_reputation, 10, @user2)
      question2.add_evaluation(:question_reputation, 2, @user1)

      xhr :get, :top 
      assigns(:users).should eq [@user2, @user1]
    end
  end
end
