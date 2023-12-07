class CreateReliefRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :relief_requests do |t|
      t.integer :volunteer_id
      t.integer :evac_id
      t.integer :disaster_id
      t.text :status
      t.text :message
      t.date :date_of_request
      t.date :date_of_dispatch

      t.timestamps
    end
  end
end
