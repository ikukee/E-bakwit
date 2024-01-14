class CreateReliefGoods < ActiveRecord::Migration[7.0]
  def change
    create_table :relief_goods do |t|
      t.text :name
      t.text :unit
      t.decimal :price

      t.timestamps
    end
  end
end
