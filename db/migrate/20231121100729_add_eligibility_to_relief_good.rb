class AddEligibilityToReliefGood < ActiveRecord::Migration[7.0]
  def change
    add_column :relief_goods, :eligibility, :text
  end
end
