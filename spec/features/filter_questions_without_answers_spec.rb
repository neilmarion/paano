require 'spec_helper'

describe "Filtering questions without an answer i.e. clicking the 'Unanswered' link at home" do
  before(:each) do
    @question = FactoryGirl.create(:user_with_a_question).questions.first
    @question_with_an_answer = FactoryGirl.create(:user_with_a_question_with_an_answer).questions.first
    visit root_path
    current_path.should eq root_path 
  end

  it "filters questions without an answer" do
    click_link I18n.t('.shared.home.left.unanswered') 
    page.should_not have_content @question_with_an_answer.title
    page.should have_content @question.title
  end
end
