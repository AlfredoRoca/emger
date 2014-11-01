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

      def here
        place = Place.new(place_params)
        place.save
        emergency = Emergency.create()
          emergency.status      = Emergency::EMERGENCY_STATUS_OPEN
          emergency.place_id    = place.id
          emergency.date        = Datetime.now
          emergency.simulacrum  = false
        emergency.save
        render json: {"place" => place, "emergency" => emergency}
      end

      private
      def place_params
        params.require(:place).permit(:name, :description, :coord_x, :coord_y)
      end

      def emergency_params
        params.require(:emergency).permit(:date, :status, :simulacrum, :place_id)
      end


    end
  end
end
