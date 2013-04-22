class Comment < Post
  belongs_to :post, :foreign_key => "post_id"
end
