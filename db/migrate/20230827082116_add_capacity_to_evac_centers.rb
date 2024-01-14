class AddCapacityToEvacCenters < ActiveRecord::Migration[7.0]
  def change
    add_column :evac_centers, :capacity, :integer
  end
end
