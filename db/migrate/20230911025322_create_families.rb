class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.string :name
      t.integer :houseNum
      t.integer :streetNum
      t.string :barangay
      t.boolean :is_4ps

      t.timestamps
    end
  end
end
