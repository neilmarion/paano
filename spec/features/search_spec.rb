require 'spec_helper'

describe "Searching" do
  let(:question){ FactoryGirl.create(:question_with_an_answer) }

  before(:each) do
    visit root_path
  end

  describe "will be successful" do
    it "after the #search_button is clicked and the relevance of the value in the #search_input query is > 0%" do
      fill_in :query, with: "question.title\n"
      page.should have_content question.title
    end
  end 

  describe "will fail" do
    it "after the #search_button is clicked and the relevance of the value in the #search_input query is < 0%" do
      fill_in :query, with: "xxx\n" 
      page.should_not have_content question.title
    end
  end
end
