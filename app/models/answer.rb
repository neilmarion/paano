class Answer < Post
  attr_accessible :question, :user
  has_reputation :votes, :source => :user
  belongs_to :question, :foreign_key => "question_id"
  before_create :inherit_question_attr
  after_create :increment_question_answers_count

  def increment_question_answers_count
    Question.increment_counter(:answers_count, question.id)
  end

  def inherit_question_attr
    self.tag_list = self.question.tag_list.join(',')
    self.user ||= self.question.user
  end
end
