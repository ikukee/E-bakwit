class FamilyMember < ApplicationRecord
    validates :sex, :family_id, :fname, :lname, :age, presence: true
    validates :age , numericality:{greater_than_or_equal_to: 0}
    belongs_to :family
end
