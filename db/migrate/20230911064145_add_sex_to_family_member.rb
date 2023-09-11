class AddSexToFamilyMember < ActiveRecord::Migration[7.0]
  def change
    add_column :family_members, :sex, :string
  end
end
