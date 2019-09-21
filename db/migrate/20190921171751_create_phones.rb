class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.references :establishment, foreign_key: true
      t.string :number

      t.timestamps
    end
  end
end
