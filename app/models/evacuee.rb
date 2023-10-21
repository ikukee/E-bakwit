class Evacuee < ApplicationRecord
    belongs_to :family
    has_many :disasters
end
