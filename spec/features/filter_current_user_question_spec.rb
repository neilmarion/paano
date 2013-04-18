require 'spec_helper'

describe "Filtering current user's question i.e. clicking the 'Mine' link at home" do
  before(:each) do
    visit root_path
    current_path.should eq root_path 
  end

  it "fails because user is not signed-in" do
    click_link I18n.t('shared.home.left.mine') 
    current_path.should eq new_user_session_path
  end

  it "succeeds because user is signed-in" do
    question = FactoryGirl.create(:question)
    User.any_instance.should_receive(:questions).and_return question

    click_link I18n.t('shared.navbar.user_links.sign_in_with_facebook')
    click_link I18n.t('shared.home.left.mine')
    #page.should have_content question.title
    pending
  end
end
