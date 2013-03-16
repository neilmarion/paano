require 'spec_helper'

describe "Signing in through Twitter Account" do
  describe "signup" do
    it "succeeds signing up through twitter" do
      visit root_path
      expect{
        click_link "Sign in with Twitter"
      }.to change(User, :count).by 1
      page.should have_link "Sign out"
    end

    it "fails signing up through twitter" do
      pending 
    end
  end

  describe "signin" do
    it "through twitter" do
      expect{
        user = FactoryGirl.create(:user_twitter, 
          uid: OmniAuth.config.mock_auth[:twitter]['uid'],
          name: OmniAuth.config.mock_auth[:twitter]['info']['name'])
      }.to change(User, :count).by 1

      expect{
        visit root_path
        click_link "Sign in with Twitter"
        page.should have_link "Sign out"
      }.to_not change(User, :count)
    end   

    it "fails signing in through twitter" do
      pending
    end
  end

end
