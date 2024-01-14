class CreateReliefGoodToEvacuees < ActiveRecord::Migration[7.0]
  def change
    create_table :relief_good_to_evacuees do |t|
      t.integer :evacuee_id
      t.integer :criterium_id
      t.integer :gen_id
      t.float :quantity

      t.timestamps
    end
  end
end
