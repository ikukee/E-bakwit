module ApplicationHelper

    def notifIcon(x)
        case x
        when 1 ## RELIEF REQ
            return ReliefRequest.all.where(status: "PENDING").length > 0 
        when 2 ## VOLUNTEER REQ
            return Request.all.where(status: "PENDING").length > 0 
        when 3
            return Request.all.where(status: "PENDING").length > 0 || ReliefRequest.all.where(status: "PENDING").length > 0 
        end
        
    end
end
