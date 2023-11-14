class AddFullNameToFamilyMember < ActiveRecord::Migration[7.0]
  def change
    add_column :family_members, :full_name, :string
  end
end
