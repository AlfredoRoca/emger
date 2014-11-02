module Api
  module V1
    class EmergenciesController < ApplicationController

      def index
        emergencies = Emergency.open.order("date DESC")
        render json: emergencies
      end

      def index_all
        emergencies = Emergency.all.order("date DESC, status ASC")
        render json: emergencies
      end

      def here_new_emergency
        place = Place.create()
          place.name = params[:name]
          place.description = params[:description]
          place.coord_x = params[:coord_x]
          place.coord_y = params[:coord_y]
        if place.save
          emergency = Emergency.create()
            emergency.status      = Emergency::EMERGENCY_STATUS_OPEN
            emergency.place_id    = place.id
            emergency.date        = DateTime::now
            emergency.simulacrum  = false
          if emergency.save
            response = {"place" => place, "emergency" => emergency}
          else
            response = "Error saving new emergency. Params: #{params}"
            status   = 451
          end
        else
          response = "Error saving new place: #{place.errors.full_messages.each{|msg| msg}}"
          status   =  450
        end
          render json: response
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
