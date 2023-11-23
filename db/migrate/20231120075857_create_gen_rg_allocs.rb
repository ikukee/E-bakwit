class CreateGenRgAllocs < ActiveRecord::Migration[7.0]
  def change
    create_table :gen_rg_allocs do |t|
      t.integer :rg_id
      t.integer :disaster_id
      t.integer :evac_id
      t.float :quantity
      t.string :name

      t.timestamps
    end
  end
end
