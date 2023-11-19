class AddIsFoodToReliefGood < ActiveRecord::Migration[7.0]
  def change
    add_column :relief_goods, :is_food, :boolean
  end
end
