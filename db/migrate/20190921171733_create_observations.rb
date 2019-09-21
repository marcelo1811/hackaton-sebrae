class CreateObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :observations do |t|
      t.references :establishment, foreign_key: true
      t.string :content
      t.references :step, foreign_key: true

      t.timestamps
    end
  end
end
