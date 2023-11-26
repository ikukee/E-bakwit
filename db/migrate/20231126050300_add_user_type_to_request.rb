class AddUserTypeToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :user_type, :string
  end
end
