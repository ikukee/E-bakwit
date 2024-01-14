class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.text :fname
      t.text :lname
      t.date :bdate
      t.text :email
      t.text :address
      t.text :status

      t.timestamps
    end
  end
end
