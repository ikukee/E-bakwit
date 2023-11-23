class AddReliefGoodStatusToEvacuee < ActiveRecord::Migration[7.0]
  def change
    add_column :evacuees, :relief_good_status, :string
  end
end
