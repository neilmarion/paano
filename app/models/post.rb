class Post < ActiveRecord::Base
  attr_accessible :content, :title, :user_id, :tag_list
  acts_as_taggable
  validates_presence_of :content
  validates_presence_of :tag_list
  belongs_to :user

  has_many :evaluations, class_name: "RSEvaluation", as: :source

  def self.text_search(query)
    if query.present?
      join_rs_reputations.where_title_and_content_matches(query).order_by_prod_of_rep_and_rel(query)
    else
      scoped
    end
  end

  scope :join_rs_reputations, 
    :joins => "LEFT JOIN rs_reputations ON posts.id = rs_reputations.target_id
        AND rs_reputations.reputation_name = 'votes'
        AND rs_reputations.active = 't'"

  scope :where_title_and_content_matches, lambda { |query|
    where("to_tsvector('english', title) @@ plainto_tsquery(:q) 
      OR to_tsvector('english', content) @@ plainto_tsquery(:q)", q: query) }

  scope :order_by_prod_of_rep_and_rel, lambda { |query|
    #order by product of reputation and relevance
    order("(COALESCE(rs_reputations.value, 0) * (#{rank(query)}) + #{rank(query)}) DESC") }

  private

  def self.rank(query)
    rank = <<-RANK
      ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)})) +
      ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
    RANK
    rank
  end
end
