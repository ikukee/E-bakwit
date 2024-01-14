class AddStatusToEvacMember < ActiveRecord::Migration[7.0]
  def change
    add_column :evac_members, :status, :text
  end
end
