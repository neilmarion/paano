class Post < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :content, :title, :tag_list, :comments_attributes, :user_id
  acts_as_taggable
  acts_as_paranoid
  validates_presence_of :content
  belongs_to :user
  has_many :comments, :dependent => :destroy

  accepts_nested_attributes_for :comments, :allow_destroy => true

  def self.text_search(query)
    if query.present?
      join_rs_reputations.where_title_and_content_matches(query).where_post_is_not_a_comment.order_by_prod_of_rep_and_rel(query)
    else
      where_post_is_not_a_comment
    end
  end

  def self.find_top_posts
    where_post_is_not_a_comment.join_rs_reputations.order_by_rep 
  end

  scope :join_rs_reputations, 
    :joins => "LEFT JOIN rs_reputations ON posts.id = rs_reputations.target_id
        AND rs_reputations.reputation_name LIKE '%reputation'
        AND rs_reputations.active = 't'"

  scope :where_title_and_content_matches, lambda { |query|
    where("to_tsvector('english', title) @@ plainto_tsquery(:q) 
      OR to_tsvector('english', content) @@ plainto_tsquery(:q)", q: query) }

  scope :where_post_is_not_a_comment,
    where("type NOT IN ('Comment')")

  scope :order_by_prod_of_rep_and_rel, lambda { |query|
    #order by product of reputation and relevance
    order("(COALESCE(rs_reputations.value, 0) * (#{rank(query)}) + #{rank(query)}) DESC") }

  scope :order_by_rep, #order by reputation
    order("COALESCE(rs_reputations.value, 0) DESC")

  scope :paginate, lambda { |page|
    page(page).per(PAGINATION['posts_index']) }

  def truncated_content
    content.truncate(200) 
  end

  def vote_count #this is slow. Extend the twitter activerecord reputation gem
    #this is also dangerous: What if the SCORING values changed?
    up_votes = ReputationSystem::Evaluation.where(reputation_name: reputation_name.to_s, target_type: self.class.name, value: up_score, target_id: id).count
    down_votes = ReputationSystem::Evaluation.where(reputation_name: reputation_name.to_s, target_type: self.class.name, value: SCORING['down'], target_id: id).count

    up_votes - down_votes
  end

  class IllegalVoting < StandardError; end

  def vote_up(voter)
    raise IllegalVoting.new(I18n.t('.activerecord.errors.models.post.violations.self_vote')) if voter == user
    add_evaluation(reputation_name, up_score, voter)
  end 

  def vote_down(voter)
    raise IllegalVoting.new(I18n.t('.activerecord.errors.models.post.violations.self_vote')) if voter == user
    add_evaluation(reputation_name, SCORING['down'], voter)
  end
  
  def reputation
    reputation_for(reputation_name).to_i
  end

  def unvote(unvoter)
    delete_evaluation(reputation_name, unvoter)
  end

  def destroy
    if self.class == Answer || self.class == Question    
      reputation_name = self.class.name == "Answer" ? :answer_reputation : :question_reputation
      evaluators = ReputationSystem::Evaluation.where(target_id: id, target_type: self.class.name, reputation_name: reputation_name)
          .collect(&:source_id)
          .collect{ |id| User.find(id) }
      # once pull request https://github.com/twitter/activerecord-reputation-system/pull/57 is approved, change it to this
      # evaluators = evaluators_for(reputation_name)

      evaluators.each do |evaluator|
        delete_evaluation(reputation_name, evaluator)
      end 
    end
    
    super
  end

  private

  def reputation_name
    self.class.name == "Answer" ? :answer_reputation : :question_reputation
  end

  def up_score
    self.class.name == "Answer" ? SCORING['up'] : SCORING['question_up']
  end

  def self.rank(query)
    rank = <<-RANK
      ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)})) +
      ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
    RANK
    rank
  end

  
end
