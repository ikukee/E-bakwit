class CreateEvacCenters < ActiveRecord::Migration[7.0]
  def change
    create_table :evac_centers do |t|
      t.string :name
      t.boolean :isInside
      t.string :barangay

      t.timestamps
    end
  end
end
