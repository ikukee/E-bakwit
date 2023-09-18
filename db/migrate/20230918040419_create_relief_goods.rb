class CreateReliefGoods < ActiveRecord::Migration[7.0]
  def change
    create_table :relief_goods do |t|
      t.string :name
      t.boolean :is_food
      t.string :unit
      t.decimal :price

      t.timestamps
    end
  end
end
