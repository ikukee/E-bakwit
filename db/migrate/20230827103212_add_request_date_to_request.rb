class AddRequestDateToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :request_date, :date
  end
end
