class RgCriterium < ApplicationRecord
    validates :criteria, :gen_rg_alloc_id, presence:true, numericality: {greater_than:0}
    
end
