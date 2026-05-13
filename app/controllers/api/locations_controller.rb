# frozen_string_literal: true

class Api::LocationsController < ApplicationController
  def index
    locations = service.find_all_locations

    render json: {
      status: "success",
      data: locations
    }
  end

  def show
    location = service.find_location_by_id(params[:id])

    if location
      render json: {
        status: "success",
        data: location
      }
    else
      render json: {
        status: "error",
        message: "Location not found"
      }, status: :not_found
    end
  end

  def create
    location = service.create_location(location_params)

    render json: {
      status: "success",
      data: location
    }
  end

  def update
    location = service.update_location(params[:id], location_params)

    if location
      render json: {
        status: "success",
        data: location
      }
    else
      render json: {
        status: "error",
        message: "Location not found"
      }, status: :not_found
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :description)
  end

  def service
    @service ||= LocationService.new
  end
end
