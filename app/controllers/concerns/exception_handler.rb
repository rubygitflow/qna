module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_request
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_entity_request
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_entity_request
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_request
  end

  private

  def json_response(object, status)
    render json: object, status: status
  end

  # JSON response with status unprocessable entity
  def unprocessable_entity_request(e)
    json_response({message: e.message}, :unprocessable_entity)
  end

  # JSON response with status unauthorized
  def unauthorized_request(e)
    json_response({message: e.message}, :unauthorized)
  end

  # JSON response with status not_found
  def not_found_request(e)
    json_response({message: e.message}, :not_found)
  end
end
