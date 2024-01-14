class EvacuationEssential < ApplicationRecord
    validates :name, :ess_type, presence:true
end
