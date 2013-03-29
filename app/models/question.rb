class Question < Post
  validates :title, :format => { :with => /(.*) to (.*)/ }
  
  has_reputation :votes, :source => :user
end
