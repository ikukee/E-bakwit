class AddFamilyNameToEvacuee < ActiveRecord::Migration[7.0]
  def change
    add_column :evacuees, :family_name, :text
  end
end
