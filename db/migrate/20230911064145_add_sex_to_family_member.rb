class AddSexToFamilyMember < ActiveRecord::Migration[7.0]
  def change
    add_column :family_members, :sex, :text
  end
end
