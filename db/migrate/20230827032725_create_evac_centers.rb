class CreateEvacCenters < ActiveRecord::Migration[7.0]
  def change
    create_table :evac_centers do |t|
      t.text :name
      t.boolean :isInside
      t.text :barangay

      t.timestamps
    end
  end
end
