class AddStatusToEvacCenter < ActiveRecord::Migration[7.0]
  def change
    add_column :evac_centers, :status, :text
  end
end
