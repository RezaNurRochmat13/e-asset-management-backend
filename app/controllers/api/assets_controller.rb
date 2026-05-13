# frozen_string_literal: true

class Api::AssetsController < ApplicationController
  before_action :authenticate_user!

  def index
    assets = service.find_all_assets
    render json: {
      status: "success",
      data: assets
    }
  end

  def show
    asset = service.find_asset_by_id(params[:id])
    if asset
      render json: {
        status: "success",
        data: asset
      }
    else
      render json: {
        status: "error",
        message: "Asset not found"
      }, status: :not_found
    end
  end

  def create
    asset = service.create_asset(asset_params, current_user.id)
    render json: {
      status: "success",
      data: asset
    }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      status: "error",
      message: e.record.errors.full_messages.join(", ")
    }, status: :unprocessable_entity
  end

  def update
    asset = service.find_asset_by_id(params[:id])
    if asset
      service.update_asset(asset, asset_params, current_user.id)
      render json: {
        status: "success",
        data: asset
      }
    else
      render json: {
        status: "error",
        message: "Asset not found"
      }, status: :not_found
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      status: "error",
      message: e.record.errors.full_messages.join(", ")
    }, status: :unprocessable_entity
  end


  private

  def asset_params
    params.require(:asset).permit(:name, :description, :asset_code, :serial_number, :asset_type, :status, :asset_image_url, :acquisition_cost, :salvage_value, :useful_life, :buy_date, :tax_date, :notes, :remarks, :location_id)
  end

  def service
    @service ||= AssetService.new
  end
end
