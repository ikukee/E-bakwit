class CreateEvacMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :evac_members do |t|
      t.integer :evacuee_id
      t.integer :member_id

      t.timestamps
    end
  end
end
