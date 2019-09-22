class AddFacebookUpdateToEstablishment < ActiveRecord::Migration[5.2]
  def change
    add_column :establishments, :facebook_update, :datetime
  end
end
