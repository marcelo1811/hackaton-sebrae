class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.references :establishment, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
