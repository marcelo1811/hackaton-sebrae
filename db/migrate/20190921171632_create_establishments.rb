class CreateEstablishments < ActiveRecord::Migration[5.2]
  def change
    create_table :establishments do |t|
      t.string :fantasy_name

      t.timestamps
    end
  end
end
