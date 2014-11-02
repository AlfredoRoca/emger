module Api
  module V1
    class EmergenciesController < ApplicationController

      def index
        emergencies = Emergency.open.order("date DESC")
        render json: emergencies
      end

      def all
        emergencies = Emergency.all.order("date DESC, status ASC")
        render json: emergencies
      end

    end
  end
end
