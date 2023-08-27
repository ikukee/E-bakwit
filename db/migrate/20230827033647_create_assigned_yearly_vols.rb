class CreateAssignedYearlyVols < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_yearly_vols do |t|
      t.integer :volunteer_id
      t.integer :evac_profile_id

      t.timestamps
    end
  end
end
