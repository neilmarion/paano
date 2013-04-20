require 'spec_helper'

describe "Answering a question in the question show page" do
  before(:each) do
    @question = FactoryGirl.create(:question)
    visit root_path
    click_link @question.title
    current_path.should eq question_path(@question)
  end
  
  it "fails if user is not yet signed in" do
    expect{ 
      fill_in :question_answers_attributes_0_content, with: "My Answer" 
      click_button I18n.t('questions.form.post')
    }.to_not change(Answer, :count)
  end

  it "succeeds if user is signed in" do
    click_link I18n.t('shared.navbar.user_links.sign_in_with_fb_link.sign_in_with_facebook')
    expect{ 
      fill_in :question_answers_attributes_0_content, with: "My Answer" 
      click_button I18n.t('questions.form.post')
    }.to_not change(Answer, :count)
  end
end
