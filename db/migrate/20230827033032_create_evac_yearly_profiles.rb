class CreateEvacYearlyProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :evac_yearly_profiles do |t|
      t.integer :evac_id
      t.integer :manager_id
      t.text :year

      t.timestamps
    end
  end
end
