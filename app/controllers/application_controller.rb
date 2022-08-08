# Application Controller for our Authenication API
class ApplicationController < ActionController::API
  before_action :authorized
  SECRET_KEY = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.2boNcrRNkzSVVzCL5ZSXlJEuFXBJQP7MIqzGcf-1j1s'.freeze
  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    token = auth_header.split(' ')[1] if auth_header
    begin
      JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
    rescue
      nil
    end
  end

  def current_user
    user_id = decoded_token[0]['user_id'] if decoded_token
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end

  def authorized
    if logged_in?
      true
    else
      render json: { message: 'Please Log in!' }, status: :unauthorized
    end
  end
end
