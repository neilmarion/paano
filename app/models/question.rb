class Question < Post
  validates_presence_of :title
  has_reputation :votes, :source => :user
  has_many :answers, :foreign_key => "question_id"

  scope :paginate, lambda { |page|
    page(page).per(PAGINATION['posts_index']) }

  def self.find_questions_without_an_answer
    Question.where("answers_count = 0")
  end
end
