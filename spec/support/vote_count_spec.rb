shared_examples "it has a reputation" do
  before(:each) do
    @user = FactoryGirl.create(:user_facebook)
  end

  it "it's (any) reputation iterates by 1 whenever a user votes up for it" do
    @post.add_evaluation(@rep, @model_class == Answer ? SCORING['up'] : SCORING['question_up'], @user)
    #@post.send(@method).should eq 1 
    @post.reputation.should eq @model_class == Answer ? SCORING['up'] : SCORING['question_up'] 
    @post.vote_count.should eq 1
  end

  it "it's (any) reputation iterates by -1 whenever a user votes down for it" do
    @post.add_evaluation(@rep, SCORING['down'], @user)
    #@post.send(@method).should eq -1
    @post.reputation.should eq SCORING['down']
    @post.vote_count.should eq -1
  end
end
