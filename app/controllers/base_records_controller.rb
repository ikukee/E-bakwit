class BaseRecordsController < ApplicationController
 
    def relief_good

    end

    def new_relief
       @relief_good = ReliefGood.new
    end

    def create_relief

    end

end
