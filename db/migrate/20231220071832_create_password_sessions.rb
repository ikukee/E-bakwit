class CreatePasswordSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :password_sessions do |t|
      t.integer :user_id
      t.date :expiration_date

      t.timestamps
    end
  end
end
