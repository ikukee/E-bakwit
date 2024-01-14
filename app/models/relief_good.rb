class ReliefGood < ApplicationRecord
    validates :name, :unit, :price,:eligibility,:category, presence: true
    validates :price, numericality:{greater_than_or_equal_to: 0}
end

