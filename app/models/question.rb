class Question < Post
#  validates :title, :format => { :with => /(.*) to (.*)/ }
  validates_presence_of :title
  has_reputation :votes, :source => :user
end
