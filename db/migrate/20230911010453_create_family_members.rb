class CreateFamilyMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :family_members do |t|
      t.integer :family_id
      t.text :fname
      t.text :lname
      t.integer :age
      t.boolean :is_pregnant
      t.boolean :is_parent
      t.boolean :is_pwd
      t.boolean :is_breastfeeding

      t.timestamps
    end
  end
end
