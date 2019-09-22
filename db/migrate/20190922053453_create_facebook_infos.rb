class CreateFacebookInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :facebook_infos do |t|
      t.string :facebook_id
      t.boolean :is_verified
      t.string :name
      t.integer :overall_star_rating
      t.integer :engagement
      t.integer :checkins
      t.integer :rating_count
      t.string :single_line_address
      t.string :phone
      t.string :facebook_link
      t.string :website

      t.timestamps
    end
  end
end
