class AddSearchIndexToPosts < ActiveRecord::Migration
  def up
    execute "create index posts_title on posts using gin(to_tsvector('english', title))"
    execute "create index posts_content on posts using gin(to_tsvector('english', content))"
  end

  def down
    execute "drop index posts_title"
    execute "drop index posts_content"
  end
end
