require 'spec_helper'

describe "On asking question" do
  describe "when successful" do
    it "goes to ask page when the #ask button is clicked" do
      visit root_path
      click_link "Sign in with Facebook"
      click_link "Ask"
      current_path.should eq new_question_path
      page.should have_link "Post"
    end
  end

  describe "when failed" do
    it "goes to /useres/login path" do
      visit root_path
      click_link "Ask"
      current_path.should eq new_user_session_path
    end
  end
end
