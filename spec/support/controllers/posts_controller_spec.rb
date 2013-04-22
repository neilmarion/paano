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
