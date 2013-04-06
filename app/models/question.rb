class Question < Post
  #this is for paanopumunta.com #validates :title, :format => { :with => /(.*) to (.*)/ }
  validates_presence_of :title, :content
  has_reputation :votes, :source => :user
  has_many :answers, :foreign_key => "question_id"
end
