class CreateEvacuationEssentials < ActiveRecord::Migration[7.0]
  def change
    create_table :evacuation_essentials do |t|
      t.text :name
      t.text :description
      t.text :ess_type

      t.timestamps
    end
  end
end
