class CreateRgCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :rg_criteria do |t|
      t.integer :gen_rg_alloc_id
      t.integer :criteria

      t.timestamps
    end
  end
end
