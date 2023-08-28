class BaseRecordsController < ApplicationController
    def index
        @base_records = BaseRecord.all
    end
    def new
        @base_records = BaseRecord.new

    end
end
