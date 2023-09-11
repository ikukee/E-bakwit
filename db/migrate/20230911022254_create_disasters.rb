class CreateDisasters < ActiveRecord::Migration[7.0]
  def change
    create_table :disasters do |t|
      t.string :name
      t.string :disaster_type
      t.date :year

      t.timestamps
    end
  end
end
