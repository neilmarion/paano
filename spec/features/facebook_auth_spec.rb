require 'spec_helper'

describe "Authorization through Facebook" do
  describe "signup (first-time sign in)" do
    it "succeeds signing up through facebook" do
      visit root_path
      expect{
        click_link "with Facebook"
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
        click_link "with Facebook"
        page.should have_link "Sign out"
      }.to_not change(User, :count)
    end   

    it "fails signing in through facebook" do
      pending
    end
  end

  describe "after authorization will redirect to previous page" do
    pending
  end

end
