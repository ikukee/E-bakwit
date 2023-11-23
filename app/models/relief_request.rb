class ReliefRequest < ApplicationRecord
    validates :volunteer_id, :evac_id, :disaster_id, :date_of_request, presence:true
    validates :volunteer_id, :evac_id, :disaster_id, numericality:{greater_than: 0}
end
