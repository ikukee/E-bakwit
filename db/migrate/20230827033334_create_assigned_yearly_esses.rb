class CreateAssignedYearlyEsses < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_yearly_esses do |t|
      t.integer :ess_id
      t.integer :evac_profile_id
      t.integer :quantity
      t.string :status

      t.timestamps
    end
  end
end
