class CreateCampManagers < ActiveRecord::Migration[7.0]
  def change
    create_table :camp_managers do |t|
      t.string :fname
      t.string :lname
      t.string :cnum
      t.string :address
      t.string :status

      t.timestamps
    end
  end
end
