class Comment < Post
  attr_accessible :post_id
  belongs_to :post, :foreign_key => "post_id"
end
