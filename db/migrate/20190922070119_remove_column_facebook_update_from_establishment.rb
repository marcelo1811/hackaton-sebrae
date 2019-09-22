class RemoveColumnFacebookUpdateFromEstablishment < ActiveRecord::Migration[5.2]
  def change
    remove_column :establishments, :facebook_update
  end
end
