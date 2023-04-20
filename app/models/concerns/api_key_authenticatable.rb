module ApiKeyAuthenticatable
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_api_key
  attr_reader :current_bearer

  # Use this to raise an error and automatically respond with a 401 HTTP status
  # code when API key authentication fails
  def authenticate_with_api_key!
    @current_bearer = authenticate_or_request_with_http_token(&method(:authenticator))
  end

  def authenticate_with_admin_key!
    @current_bearer = authenticate_or_request_with_http_token(&method(:admin_authenticator))
  end

  private

  attr_writer :current_api_key, :current_bearer

  def authenticator(http_token, options)
    @current_api_key = ApiKey.authenticate_by_token token: http_token

    current_api_key&.bearer
  end

  def admin_authenticator(http_token, options)
    @current_api_key = ApiKey.authenticate_by_token token: http_token
    return false unless current_api_key&.bearer&.role == 'admin'

    current_api_key&.bearer
  end
end
