class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :neighborhood
      t.integer :number
      t.string :city

      t.timestamps
    end
  end
end
