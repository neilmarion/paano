require 'spec_helper'

describe "questions/index.html.erb" do
  before(:each) do
    stubs = [stub_model(Question, :title => "Question 1", :question => "Question 1 Content", :type => "Question")]
    assign(:questions, stubs)
  end
  
  it "renders index of questions" do
    render
    render.should have_link("Question 1")
  end
end

describe "questions/new.html.erb" do
  pending
end
