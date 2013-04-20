class Question < Post
  attr_accessible :answers_attributes
  validates_presence_of :title, :tag_list
  has_reputation :votes, :source => :user
  has_many :answers, :foreign_key => "question_id"
  accepts_nested_attributes_for :answers, :allow_destroy => true

  scope :paginate, lambda { |page|
    page(page).per(PAGINATION['posts_index']) }

  def self.find_questions_without_an_answer
    Question.where("answers_count = 0")
  end
end
