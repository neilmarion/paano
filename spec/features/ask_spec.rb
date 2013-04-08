require 'spec_helper'

describe "On asking question" do
  describe "when successful" do
    it "goes to ask page when the #ask button is clicked" do
      visit root_path
      click_link "Sign in with Facebook"
      click_link "Ask"
      current_path.should eq new_question_path
      page.should have_button "Post"
    end
  end

  describe "when failed" do
    it "goes to /useres/login path" do
      visit root_path
      click_link "Ask"
      current_path.should eq new_user_session_path
    end
  end

  describe "on click of post" do
    it "will successfully post the question" do
      visit root_path
      click_link "Sign in with Facebook"
      click_link "Ask"
      question_title = "Question Title"
      question_content = "Question Content"
      question_tag = "question_tag"
      fill_in "question_title", with: question_title 
      fill_in "question_content", with: question_content 
      fill_in "question_tag_list", with: question_tag
      click_button "Post"
      page.should have_content question_title
      page.should have_content question_content
      page.should have_content question_tag
    end 

    it "will render nothing and output error message when #question_title field is blank" do
      visit root_path
      click_link "Sign in with Facebook"
      click_link "Ask"
      question_title = "Question Title"
      question_content = "Question Content"
      fill_in "question_title", with: question_title 
      fill_in "question_content", with: question_content 
      click_button "Post"
      page.should have_content I18n.t('activerecord.errors.models.post.attributes.tag_list.blank')
    end

    it "will render nothing and output error message when #question_content field is blank" do
      pending
    end

    it "will render nothing and output error message when #question_tag_list field is blank" do
      pending
    end
  end
end
