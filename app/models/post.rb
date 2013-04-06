class Post < ActiveRecord::Base
  attr_accessible :content, :title, :user_id

  belongs_to :user

  has_many :evaluations, class_name: "RSEvaluation", as: :source

  scope :join_rs_reputations, 
    :joins => "LEFT JOIN rs_reputations ON posts.id = rs_reputations.target_id
        AND rs_reputations.reputation_name = 'votes'
        AND rs_reputations.active = 't'"

  def self.text_search(query)
    if query.present?
      rank = <<-RANK
        ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)})) +
        ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
      RANK
      join_rs_reputations.where("to_tsvector('english', title) @@ plainto_tsquery(:q) or to_tsvector('english', content) @@ plainto_tsquery(:q)", q: query).order("(COALESCE(rs_reputations.value, 0) * (#{rank}) + #{rank}) DESC")
    else
      scoped
    end
  end

end
