class AddExpDateToPasswordSession < ActiveRecord::Migration[7.0]
  def change
    add_column :password_sessions, :exp_date, :datetime
  end
end
