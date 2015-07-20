class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.string :image_url
  		t.string :caption
  		t.string :location
  		t.datetime :created_at
  		t.integer :user_id
  	end
  end
end
