class Answer < Post
  has_reputation :votes, :source => :user
  belongs_to :question, :foreign_key => "question_id"
end
