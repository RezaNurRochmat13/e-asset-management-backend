# frozen_string_literal: true

class AuthenticationService
  def register(params)
    User.create!(params)
  end

  def login(email, password)
    user = User.find_by(email: email)

    if user&.authenticate(password)
      JwtUtil.encode({ user_id: user.id, username: user.username, email: user.email })
    else
      nil
    end
  end
end
