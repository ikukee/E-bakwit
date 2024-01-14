class AddZoneToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :zone, :integer
  end
end
