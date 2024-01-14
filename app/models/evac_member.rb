class EvacMember < ApplicationRecord

    validates :evacuee_id, :member_id ,presence: true, numericality:{greater_than: 0}
end
