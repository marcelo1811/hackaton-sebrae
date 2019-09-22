class CreateFacebookLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :facebook_locations do |t|
      t.references :facebook_info, foreign_key: true
      t.string :city
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
