class AddFacebookUpdatedAtToEstablishments < ActiveRecord::Migration[5.2]
  def change
    add_column :establishments, :facebook_updated_at, :datetime
  end
end
