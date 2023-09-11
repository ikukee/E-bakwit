class ReliefGood < ApplicationRecord
    validates :name, :is_food, :unit, :price, presence: true
    validates :price, numericality:{greater_than_or_equal_to: 0}
end
