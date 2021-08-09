# frozen_string_literal: true

module ErrorResponse # :nodoc:
  extend ActiveSupport::Concern

  STATUS_CODES = {
    BAD_REQUEST: 400,
  }.freeze

  included do
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end

  private

  def bad_request(exception)
    message = exception&.message
    render_exception(STATUS_CODES[:BAD_REQUEST], message)
  end

  def render_exception(code, message)
    render json: {
      errors: [
        {
          code: STATUS_CODES.key(code),
          status: code,
          detail: message
        }
      ]
    }, status: code
  end
end
