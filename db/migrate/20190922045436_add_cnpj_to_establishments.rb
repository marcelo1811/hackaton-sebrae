class AddCnpjToEstablishments < ActiveRecord::Migration[5.2]
  def change
    add_column :establishments, :cnpj, :string
  end
end
