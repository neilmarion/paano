require 'spec_helper'

describe 'clicking a question link' do
  it 'goes to the question page' do
    user = FactoryGirl.create(:user_with_a_question)
    question = user.questions.first
    visit root_path
    click_link "Q: #{question.title}"
    page.should have_content(question.title)
    page.should have_content(question.content)
    page.should have_content(question.user.name)
  end
end

describe 'clicking an answer link' do
  it "goes to the answer's question page" do
    user_1 = FactoryGirl.create(:user_with_a_question)
    user_2 = FactoryGirl.create(:user_with_an_answer)
    question = user_1.questions.first
    question.answers << user_2.answers.first
    visit root_path
    click_link "A: #{question.answers.first.question.title}"
    page.should have_content(question.title)
    page.should have_content(question.content)
    page.should have_content(question.answers.first.content)
    page.should have_content(question.user.name)
    #other things
  end
end
