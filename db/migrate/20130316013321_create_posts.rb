class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, :default => ""
      t.text :content
      t.string :type
      t.integer :answers_count, :default => 0
      t.integer :user_id
      t.integer :post_id #self reference since an answer belongs to a question
      t.timestamps
    end
  end
end
