class CreateEvacuees < ActiveRecord::Migration[7.0]
  def change
    create_table :evacuees do |t|
      t.integer :disaster_id
      t.integer :family_id
      t.datetime :date_in
      t.datetime :date_out
      t.integer :evac_id

      t.timestamps
    end
  end
end
