class AddBatchToreliefGoodToEvacuee < ActiveRecord::Migration[7.0]
  def change
    add_column :relief_good_to_evacuees, :batch, :integer
  end
end
