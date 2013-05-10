class Answer < Post
  attr_accessible :post_id, :user_id
  has_reputation :answer_reputation, :source => :user, :source_of => { reputation: :karma, of: :user }
  has_reputation :answer_vote_count, :source => :user
  belongs_to :question, :foreign_key => "post_id"
  before_create :inherit_question_attr
  after_create :increment_question_answers_count

  def increment_question_answers_count
    Question.increment_counter(:answers_count, question.id)
  end

  def inherit_question_attr
    self.tag_list = self.question.tag_list.join(',')
    self.user ||= self.question.user
  end

  def votes
    reputation_for(:answer_reputation).to_i
  end 

  def vote_count
    reputation_for(:answer_vote_count) 
  end
end
