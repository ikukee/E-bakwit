class DispatchedRg < ApplicationRecord
    validates :request_id, :quantity, numericality:{greater_than:0}, presence: true
    validates :rg_id,presence: true
end
