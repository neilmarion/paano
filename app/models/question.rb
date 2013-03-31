class Question < Post
#  validates :title, :format => { :with => /(.*) to (.*)/ }
  validates_presence_of :title
  has_reputation :votes, :source => :user
  has_many :answers, :foreign_key => "question_id"
end
