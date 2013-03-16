require 'spec_helper'

describe "Signing in through Facebook Account" do
  describe "signup" do
    it "succeeds signing up through facebook" do
      visit root_path
      expect{
        click_link "Sign in with Facebook"
      }.to change(User, :count).by 1
      page.should have_link "Sign out"
    end

    it "fails signing up through facebook" do
      pending 
    end
  end

  describe "signin" do
    it "through facebook" do
      expect{
        user = FactoryGirl.create(:user_facebook, 
          uid: OmniAuth.config.mock_auth[:facebook]['uid'],
          name: OmniAuth.config.mock_auth[:facebook]['info']['name'])
      }.to change(User, :count).by 1

      expect{
        visit root_path
        click_link "Sign in with Facebook"
        page.should have_link "Sign out"
      }.to_not change(User, :count)
    end   

    it "fails signing in through facebook" do
      pending
    end
  end

end
