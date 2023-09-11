class BaseRecordsController < ApplicationController
    def index
       
    end
    def new
        @base_records = BaseRecord.new

    end
    def family_form
    end
end
