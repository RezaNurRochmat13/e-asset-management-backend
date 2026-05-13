# frozen_string_literal: true

class LocationService
  def find_all_locations
    Location.all
  end

  def find_location_by_id(id)
    Location.find(id)
  end

  def create_location(params)
    Location.create(params)
  end

  def update_location(id, params)
    location = Location.find(id)
    location.update(params) if location

    location
  end
end
