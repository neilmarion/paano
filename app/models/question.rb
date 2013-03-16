class Question < Post
  validates :title, :format => { :with => /(.*) to (.*)/ }
end
