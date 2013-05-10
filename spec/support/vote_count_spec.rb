shared_examples "it has vote_count reputation" do
  before(:each) do
    @user = FactoryGirl.create(:user_facebook)
  end

  it "it's vote count iterates by 1 whenever a user votes up for it" do
    @post.add_evaluation(@rep, SCORING['vote_up'], @user)
    @post.vote_count.should eq SCORING['vote_up']
  end

  it "it's vote count iterates by -1 whenever a user votes down for it" do
    @post.add_evaluation(@rep, SCORING['vote_down'], @user)
    @post.vote_count.should eq SCORING['vote_down']
  end
end
