require 'spec_helper'

describe "Filtering top questions i.e. clicking the 'Top' link at home" do
  include_context "shared features stuff"

  before(:each) do
    title = "title"
    content = "title"
    tag_list = "tag"
    @post_1 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
    @post_2 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
    @post_2.add_evaluation(:question_reputation, 10, FactoryGirl.create(:user_facebook))
    visit root_path
    current_path.should eq root_path 
  end

  it "filters questions without an answer" do
    page.body.should =~ /#{@post_2.title}.*#{@post_1.title}/ 
    page_should_have_votes_count(@post_1.reputation)
    page_should_have_votes_count(@post_2.reputation)
  end
end
