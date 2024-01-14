class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.text :name
      t.integer :houseNum
      t.integer :streetNum
      t.text :barangay
      t.boolean :is_4ps

      t.timestamps
    end
  end
end
