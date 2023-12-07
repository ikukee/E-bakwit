class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.text :fname
      t.text :lname
      t.text :password_digest
      t.text :email
      t.text :cnum
      t.text :user_type

      t.timestamps
    end
  end
end
