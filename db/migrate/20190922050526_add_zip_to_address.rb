class AddZipToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :zip, :string
  end
end
