shared_examples "it has a reputation" do
  before(:each) do
    @user = FactoryGirl.create(:user_facebook)
  end

  it "it's (any) reputation iterates by 1 whenever a user votes up for it" do
    @post.add_evaluation(@rep, 1, @user)
    @post.send(@method).should eq 1 
  end

  it "it's (any) reputation iterates by -1 whenever a user votes down for it" do
    @post.add_evaluation(@rep, -1, @user)
    @post.send(@method).should eq -1
  end
end
