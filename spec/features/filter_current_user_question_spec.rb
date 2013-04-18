require 'spec_helper'

describe "Filtering current user's question i.e. clicking the 'Mine' link at home" do
  before(:each) do
    @user = FactoryGirl.create(:user_facebook)
    @question_1 = FactoryGirl.create(:question, user: @user)
    @question_2 = FactoryGirl.create(:question) #noise question
    visit root_path
    current_path.should eq root_path 
  end

  it "fails because user is not signed-in" do
    click_link I18n.t('shared.home.left.mine') 
    current_path.should eq new_user_session_path
  end

  it "succeeds because user is signed-in" do
    # at user sign in, it should show the user's questions
    pending
  end
end
