class Disaster < ApplicationRecord
    validates :name, :disaster_type, :year , presence:true
    has_many :evacuees
end
# rails g model Evacuee disaster_id:integer family_id:integer date_in:datetime date_out:datetime evac_id:integer