module Api
  module V1
    class PlacesController < ApplicationController

      def only_pinned_places
        places = Place.pinned
        render json: places
      end

      def one_place_by_id
        place = Place.find(params[:id])
        render json: place
      end

      def index
        places = Place.all.order("name ASC")
        render json: places
      end

      def index_order_by_id
        places = Place.all.order("id DESC")
        render json: places
      end

    end
  end
end
