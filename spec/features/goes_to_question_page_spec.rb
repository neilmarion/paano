require 'spec_helper'

describe 'clicking a question link' do
  it 'goes to the question page' do
    question = FactoryGirl.create(:question)
    visit root_path
    click_link "Q: #{question.title}"
    page.should have_content(question.title)
    page.should have_content(question.content)
  end
end

describe 'clicking an answer link' do
  it "goes to the answer's question page" do
    question = FactoryGirl.create(:question_with_an_answer)  
    visit root_path
    click_link "A: #{question.answers.first.question.title}"
    page.should have_content(question.title)
    page.should have_content(question.content)
  end
end
