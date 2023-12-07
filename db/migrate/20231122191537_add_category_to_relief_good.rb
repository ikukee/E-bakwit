class AddCategoryToReliefGood < ActiveRecord::Migration[7.0]
  def change
    add_column :relief_goods, :category, :text
  end
end
