require 'spec_helper'

describe "Asking a question" do
  let(:question_title) { "Question Title" }
  let(:question_content) { "Question Content" } 
  let(:question_tag_list) { "question_tag" }

  before(:each) do
    visit root_path
  end

  describe "will be successful if user is signed in" do
    before(:each) do
      click_link I18n.t('shared.navbar.user_links.sign_in_with_fb_link.sign_in_with_facebook')
      click_link I18n.t('shared.search_field.search_field_holder.ask')
      page.should have_button I18n.t('questions.form.post')
      current_path.should eq new_question_path
    end

    it "and all fields are filled-in completely" do
      fill_in :question_title, with: question_title 
      fill_in :question_content, with: question_content 
      fill_in :question_tag_list, with: question_tag_list
      click_button I18n.t('questions.form.post') 
      page.should have_content question_title
      page.should have_content question_content
      page.should have_content question_tag_list
    end

    it "but will not post a question and return back to previous page when '#cancel_button is clicked'" do
      click_link "cancel_link"  
      current_path.should eq root_path
    end
  end
  
  describe "will fail" do
    it "if #ask button is clicked without even signing in then will be redirected to new_user_session_path" do
      click_link I18n.t('shared.search_field.search_field_holder.ask')
      current_path.should eq new_user_session_path
    end

    describe "and render nothing then outputs error messages if #post button is clicked and" do
      before(:each) do
        click_link I18n.t('shared.navbar.user_links.sign_in_with_fb_link.sign_in_with_facebook')
        click_link I18n.t('shared.search_field.search_field_holder.ask')
        page.should have_button I18n.t('questions.form.post')
        current_path.should eq new_question_path
      end

      it "#question_title field is blank" do
        fill_in :question_content, with: question_content 
        fill_in :question_tag_list, with: question_tag_list
        click_button "post_button"
        page.should have_content I18n.t('activerecord.errors.models.post.attributes.title.blank')
      end


      it "#question_content field is blank" do
        fill_in :question_title, with: question_title 
        fill_in :question_tag_list, with: question_tag_list
        click_button I18n.t('questions.form.post') 
        page.should have_content I18n.t('activerecord.errors.models.post.attributes.content.blank')
      end

      it "#question_tag_list field is blank" do 
        fill_in :question_title, with: question_title 
        fill_in :question_content, with: question_content
        click_button I18n.t('questions.form.post')
        page.should have_content I18n.t('activerecord.errors.models.post.attributes.tag_list.blank')
      end
    end
  end

end
