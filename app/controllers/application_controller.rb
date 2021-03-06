class ApplicationController < ActionController::API
  include Concerns::Authentication

  rescue_from ActionController::BadRequest, :with => :bad_request
  rescue_from ActionController::ParameterMissing, :with => :bad_request
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from Rack::OAuth2::Server::Abstract::BadRequest, :with => :bad_request
  rescue_from UsersApi::Unauthorized, :with => :unauthorized

  def bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def unauthorized(error)
    render json: { error: error.message }, status: :unauthorized
  end
end
