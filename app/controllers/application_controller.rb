class ApplicationController < ActionController::API
  def authenticate_user!
    # Skip authentication in development/test environments
    return true if Rails.env.development? || Rails.env.test?
    

    api_key = ApiKey.find_by(token: request.session[:token])
    @current_user = api_key&.bearer
    head :unauthorized unless @current_user if @current_user.nil?
  end
end