class Question < Post
  attr_accessible :answers_attributes
  validates_presence_of :title, :tag_list
  validates_format_of :tag_list, :with => /^(([a-z0-9\-\_]+[^ ])+(, )?)+$/ 
  has_reputation :question_reputation, :source => :user, :source_of => { reputation: :karma, of: :user }
  has_reputation :question_vote_count, :source => :user
  has_many :answers, :foreign_key => "post_id", :dependent => :destroy
  accepts_nested_attributes_for :answers, :allow_destroy => true

  scope :paginate, lambda { |page|
    page(page).per(PAGINATION['posts_index']) }

  def self.find_questions_without_an_answer
    Question.where("answers_count = 0")
  end

  def reputation 
    reputation_for(:question_reputation).to_i
  end

  def vote_count
    reputation_for(:question_vote_count).to_i
  end
end
