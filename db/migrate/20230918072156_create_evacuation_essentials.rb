class CreateEvacuationEssentials < ActiveRecord::Migration[7.0]
  def change
    create_table :evacuation_essentials do |t|
      t.string :name
      t.string :description
      t.string :ess_type

      t.timestamps
    end
  end
end
