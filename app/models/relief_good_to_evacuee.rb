class ReliefGoodToEvacuee < ApplicationRecord
    validates :evacuee_id, :criterium_id, :gen_id, :quantity, presence: true, numericality:{greater_than:0}
end
