class RemovePosts < ActiveRecord::Migration[7.0]
  def change
    drop_table :posts
  end
end
