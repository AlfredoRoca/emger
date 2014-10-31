module Api
  module V1
    class EmergenciesController < ApplicationController

      def index
        emergencies = Emergency.open.order("date ASC")
        render json: emergencies
      end

      def index_all
        emergencies = Emergency.all.order("date ASC, status ASC")
        render json: emergencies
      end

    end
  end
end
