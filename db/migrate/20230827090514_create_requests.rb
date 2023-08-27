class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string :fname
      t.string :lname
      t.date :bdate
      t.string :email
      t.string :address
      t.string :status

      t.timestamps
    end
  end
end
