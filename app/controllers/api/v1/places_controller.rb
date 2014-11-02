module Api
  module V1
    class PlacesController < ApplicationController

      def index
        places = Place.all.order("name ASC")
        render json: places
      end

      def order_by_id
        places = Place.all.order("id DESC")
        render json: places
      end

      def pinned
        places = Place.pinned
        render json: places
      end

      def show
        place = Place.find(params[:id])
        render json: place
      end

    end
  end
end
