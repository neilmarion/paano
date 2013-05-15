require 'spec_helper'

describe "clicking sorting users links" do
  include_context "shared features stuff"
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
