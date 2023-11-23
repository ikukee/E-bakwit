class GenRgAlloc < ApplicationRecord
    validates :evac_id, :disaster_id, :rg_id, :quantity, :name,:price, presence:true
    validates :evac_id, :disaster_id,:price, numericality:{greater_than:0}
    validates :quantity , numericality:{greater_than: -1}
end
