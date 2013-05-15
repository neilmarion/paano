require 'spec_helper'

describe "clicking sorting users links" do
  before(:each) do
    visit root_path
    @user = FactoryGirl.create(:user_facebook)
    current_path.should eq recent_posts_path 
  end 

  it "on recent users" do
    click_link I18n.t('.shared.home.left.recent_users')
    page.should have_content @user.name
  end 

  it "on top users" do
    click_link I18n.t('.shared.home.left.top_users')
    page.should have_content @user.name
  end

  
end

describe "clicking a user name link" do
  before(:each) do
    @user = FactoryGirl.create(:user_facebook)
    @question = FactoryGirl.create(:question, user: @user)
    @answer = FactoryGirl.create(:answer, user: @answer, question: @question)
    visit recent_users_path
  end

  it "should lead to the user's profile page" do
    click_link @user.name
    current_path.should eq user_path(@user)
    page.should have_link @question.title
    page.should have_link @answer.title
  end
end
