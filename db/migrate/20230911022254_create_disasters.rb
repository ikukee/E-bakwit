class CreateDisasters < ActiveRecord::Migration[7.0]
  def change
    create_table :disasters do |t|
      t.text :name
      t.text :disaster_type
      t.text :year

      t.timestamps
    end
  end
end
