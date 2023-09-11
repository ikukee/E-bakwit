class Disaster < ApplicationRecord
    validates :name, :disaster_type, :year , presence:true
end
