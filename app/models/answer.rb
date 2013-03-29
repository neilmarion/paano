class Answer < Post
  has_reputation :votes, :source => :user
end
