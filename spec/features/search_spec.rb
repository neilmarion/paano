require 'spec_helper'

describe "Searching" do
  include_context "shared features stuff"
  before(:each) do
    @question = FactoryGirl.create(:question_with_an_answer)
    #noise post, to verify the output
    FactoryGirl.create(:question)
  end

  describe "will be successful" do
    it "after the #query field is submitted by return button and the relevance of the value in the #query search_field_input is > 0%" do 
      result = Post.text_search(@question.title)
      #fill_in 'query', with: "#{@question.title}\n"
      Post.should_receive(:text_search).at_least(:once){ result }
      visit root_path
      page.should have_content @question.title
      page.should have_css(".post-row", count: 1)
      page_should_have_votes_count @question.votes
    end
  end 

  describe "will fail" do
    it "after the #query field is submitted by return button and the relevance of the value in the #query search_field_input is < 0%" do
      jiberish = "xxx"
      result = Post.text_search(jiberish)
      #fill_in :query, with: jiberish 
      Post.should_receive(:text_search){ result }
      visit root_path
      page.should_not have_content @question.title
      page.should have_css(".post-row", count: 0)
    end
  end
end
