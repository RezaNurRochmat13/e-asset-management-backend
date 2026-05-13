class Api::AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, raise: false, only: [ :register, :login ]

  def register
    user = service.register(register_params)
    render json: {
      status: "success",
      message: "User registered successfully",
      data: { id: user.id, username: user.username, email: user.email }
    }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      status: "error",
      message: e.record.errors.full_messages.join(", ")
    }, status: :unprocessable_entity
  end


  def login
    token = service.login(params[:email], params[:password])

    if token
      render json: {
        status: "success",
        message: "Login successful",
        data: { token: token }
      }
    else
      render json: {
        status: "error",
        message: "Invalid email or password"
      }, status: :unauthorized
    end
  end

  private

  def register_params
    params.require(:user).permit(:username, :email, :password, :first_name, :last_name)
  end

  def service
    @service ||= AuthenticationService.new
  end
end
