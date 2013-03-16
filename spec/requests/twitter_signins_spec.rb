require 'spec_helper'

describe "Signing in through Twitter Account" do
  before(:each) do
    @user = FactoryGirl.create(:user_twitter);
  end
  
  describe "signin" do
    it "through twitter" do
      visit root_path
      click_link "Sign in with Twitter"
      Authentication.last.uid.should == '123545'
    end
  end

end
