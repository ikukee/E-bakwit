class AddStreetNameToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :streetName, :text
  end
end
