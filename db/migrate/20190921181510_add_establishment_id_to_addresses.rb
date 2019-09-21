class AddEstablishmentIdToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :establishment, foreign_key: true
  end
end
