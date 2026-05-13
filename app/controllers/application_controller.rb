class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def current_user
    return @current_user if @current_user

    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?
    decoded = JwtUtil.decode(token) if token

    @current_user = User.find_by(id: decoded[:user_id]) if decoded
  end

  private

  def authenticate_user!
    unless current_user
      render json: { status: "error", message: "Unauthorized" }, status: :unauthorized
    end
  end
end
