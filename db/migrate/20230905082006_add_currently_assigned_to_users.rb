class AddCurrentlyAssignedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :currently_assigned, :integer
  end
end
