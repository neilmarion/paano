include ActsAsTaggableOn::TagsHelper

module PostsHelper
  def current_class(param)
    return 'active' if request.fullpath.match param
  end
end
