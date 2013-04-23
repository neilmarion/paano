require 'spec_helper'

describe "Filtering current user's question i.e. clicking the 'Mine' link at home" do
  include_context "shared features stuff"
  before(:each) do
    visit root_path
    current_path.should eq root_path 
  end

  it "the filter-by-current-user's-question will not be shown if the user is not logged in ('Mine')" do
    page.should_not have_link I18n.t('shared.home.left.mine')
  end

  it "succeeds because user is signed-in" do
    question = FactoryGirl.create(:question)
    User.any_instance.should_receive(:questions).and_return question

    click_link I18n.t('general.sign_in_with_facebook')
    click_link I18n.t('shared.home.left.mine')
    #page.should have_content question.title
    pending
  end
end
