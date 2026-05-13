# spec/services/authentication_service_spec.rb
require 'rails_helper'

RSpec.describe AuthenticationService, type: :service do
  let(:service) { AuthenticationService.new }
  let(:password) { 'password123' }
  let!(:user) { create(:user, username: 'reza_dev', email: 'reza_dev@example', password: password) }

  describe '#register' do
    let(:register_params) do
      {
        username: 'new_user',
        email: 'new@example.com',
        password: 'password123',
        first_name: 'New',
        last_name: 'User'
      }
    end

    it 'creates a new user' do
      expect { service.register(register_params) }.to change(User, :count).by(1)
    end
  end

  describe '#login' do
    it 'returns a valid JWT token string when credentials are correct' do
      token = service.login(user.email, user.password)
      expect(token).to be_a(String)

      decoded = JwtUtil.decode(token)
      expect(decoded[:user_id]).to eq(user.id)
    end

    it 'returns nil when password is wrong' do
      token = service.login(user.email, 'wrong_pass')
      expect(token).to be_nil
    end

    it 'returns nil when email is not found' do
      token = service.login('wrong_email', password)
      expect(token).to be_nil
    end
  end
end
