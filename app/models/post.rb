class Post < ActiveRecord::Base
  attr_accessible :content, :title, :user_id

  belongs_to :user

  def self.text_search(query)
    if query.present?
      rank = <<-RANK
        ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)})) +
        ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
      RANK
      where("to_tsvector('english', title) @@ plainto_tsquery(:q) or
        to_tsvector('english', content) @@ plainto_tsquery(:q)", q: query).order("#{rank} desc")
    else
      scoped
    end
  end

end
