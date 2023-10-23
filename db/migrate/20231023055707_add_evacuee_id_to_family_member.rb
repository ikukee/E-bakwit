class AddEvacueeIdToFamilyMember < ActiveRecord::Migration[7.0]
  def change
    add_column :family_members, :evacuee_id, :integer
  end
end
