class Api::BaseController < ApplicationController
  before_action :authorize_user_doorkeeper_access
  before_action :doorkeeper_authorize!

  private

  def authorize_user_doorkeeper_access
    current_user
  end

  def render_response(message, code)
    render json: { message: message }, status: code
  end

  def render_error_response(message)
    render_response(message, 400)
  end

  def render_success_response(message)
    render_response(message, 200)
  end
end
