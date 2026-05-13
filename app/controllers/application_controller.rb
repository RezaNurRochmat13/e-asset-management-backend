class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def current_user
    @current_user ||= find_user_from_auth_header
  end

  private

  def find_user_from_auth_header
    auth_header = request.headers["Authorization"]
    return nil if auth_header.blank?

    user_id = auth_header.split(" ").last
    User.find_by(id: user_id)
  end

  def authenticate_user!
    unless current_user
      render json: { status: "error", message: "Unauthorized" }, status: :unauthorized
    end
  end
end
