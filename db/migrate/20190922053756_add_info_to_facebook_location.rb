class AddInfoToFacebookLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :facebook_locations, :state, :string
    add_column :facebook_locations, :street, :string
    add_column :facebook_locations, :zip, :string
  end
end
