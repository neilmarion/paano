shared_examples "a user posted on a post" do
  include_context "common controller stuff"

  describe "fails" do
    it 'if user is not yet signed in' do #for commenting on answers 
      expect{
        xhr :put, :update, {id: @post.id, @post_key=>{@post_of_post_attributes_key=> {'0'=>{:content=>"My Post"}}}} 
      }.to_not change(Post, :count)
    end 

    it 'if content is blank' do
      sign_in_user
      expect{
        xhr :put, :update, {id: @post.id, @post_key=>{@post_of_post_attributes_key=> {'0'=>{:content=>""}}}} 
      }.to_not change(Post, :count)
    end 
  end 

  it 'succeeds if a user is signed in' do #for commenting on answers 
    sign_in_user
    expect{
      xhr :put, :update, {id: @post.id, @post_key=>{@post_of_post_attributes_key=> {'0'=>{:content=>"My Post"}}}} 
    }.to change(Post, :count).by 1
  end 
end

shared_examples "a user voted on a post" do
  describe  "vote_up" do
    it "succeeds" do
      expect{
        expect{
          xhr :put, :vote_up, @params
        }.to change{@post.reputation_for(@rep_name)}.by SCORING['up']
      }.to change(@post, :vote_count).by SCORING['vote_up']
    end 

    it "fails" do
      @model_class.any_instance.should_receive(:add_evaluation).and_return false 
      expect{
        expect{
          xhr :put, :vote_up, @params
        }.to_not change{@post.reputation_for(@rep_name)}
      }.to_not change(@post, :vote_count)
    end 
  end 

  describe "with vote_down" do
    it "succeeds" do
      expect{
        expect{
          xhr :get, :vote_down, @params
        }.to change{@post.reputation_for(@rep_name)}.by SCORING['down']
      }.to change(@post, :vote_count).by SCORING['vote_down']
    end 

    it "fails" do
      @model_class.any_instance.should_receive(:add_evaluation).and_return false 
      expect{
        expect{
          xhr :get, :vote_down, @params
        }.to_not change{@post.reputation_for(@rep_name)}
      }.to_not change(@post, :vote_count)
    end 
  end 
end

shared_examples "a user not signed in attempted to delete a post" do
  it "will fail to destroy the record" do
    expect{
      xhr :post, :destroy, {id: @comment.id}
    }.to_not change(Comment, :count)
    should_be_unauthorized_access 
  end
end
