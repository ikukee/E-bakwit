class AddBdateToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bdate, :date
  end
end
