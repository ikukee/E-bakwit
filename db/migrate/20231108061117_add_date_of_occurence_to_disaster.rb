class AddDateOfOccurenceToDisaster < ActiveRecord::Migration[7.0]
  def change
    add_column :disasters, :date_of_occurence, :date
  end
end
