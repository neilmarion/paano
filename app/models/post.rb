class Post < ActiveRecord::Base
  attr_accessible :content, :title, :user_id, :tag_list, :comments_attributes
  acts_as_taggable
  validates_presence_of :content
  belongs_to :user

  has_many :comments

  accepts_nested_attributes_for :comments, :allow_destroy => true
  has_many :evaluations, class_name: "RSEvaluation", as: :source

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

  private

  def self.rank(query)
    rank = <<-RANK
      ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)})) +
      ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
    RANK
    rank
  end
end
