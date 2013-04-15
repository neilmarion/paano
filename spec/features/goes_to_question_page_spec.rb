require 'spec_helper'

describe 'clicking a question link' do
  it 'goes to the question page' do
    question = FactoryGirl.create(:question)
    visit root_path
    click_link "Q: #{question.title}"
    page.should have_content(question.title)
    page.should have_content(question.content)
    page.should have_content(question.user.name)
  end
end

describe 'clicking an answer link' do
  it "goes to the answer's question page" do
    answer = FactoryGirl.create(:answer)
    question = answer.question
    visit root_path
    click_link "A: #{question.title}"
    page.should have_content(question.title)
    page.should have_content(question.content)
    page.should have_content(question.answers.first.content)
    page.should have_content(question.user.name)
    #other things
  end
end
