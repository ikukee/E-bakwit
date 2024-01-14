class AddIsEvacuatedToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :is_evacuated, :boolean
  end
end
