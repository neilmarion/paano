require 'spec_helper'

describe "clicking sorting users links" do
  include_context "shared features stuff"
  before(:each) do
    visit root_path
    @user = FactoryGirl.create(:user_facebook)
    current_path.should eq recent_posts_path 
  end 

  it "on recent users" do
    User.any_instance.should_receive(:recent).and_return @user
    click_link I18n.t('shared.home.left.users')
    page.should have_link @user.name
  end 

  it "on top users" do
    User.any_instance.should_receive(:top).and_return @user
    click_link I18n.t('shared.home.top.users')
    page.should have_link @user.name
  end
end
