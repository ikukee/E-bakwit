class CreateDispatchedRgs < ActiveRecord::Migration[7.0]
  def change
    create_table :dispatched_rgs do |t|
      t.integer :request_id
      t.integer :rg_id
      t.integer :quantity
      t.string :name

      t.timestamps
    end
  end
end
