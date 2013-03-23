require 'spec_helper'

describe "Signing out" do
  it "successfully signs out" do
    visit root_path
    click_link "Sign in with Facebook"
    page.should have_link "Sign out"
    click_link "Sign out"
    page.should have_link "Sign in with Facebook"
  end

end
