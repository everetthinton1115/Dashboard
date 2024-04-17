class Api::Users::SessionsController < Api::BaseController
  skip_before_action :doorkeeper_authorize!, only: %I[create]
  before_action :set_user, only: %I[create]
  skip_before_action :verify_authenticity_token

  def create

    unless params[:uuid] || params[:email]
      return render json: {
        message: 'Required parameters are missing.',
        logged_in: false,
        success: false
      }
    end

    if params[:uuid]
      @user = User.find_by(uuid: params[:uuid])
      unless @user
        return render json: {
          message: 'Please try to login with global ID or Reset your password.',
          logged_in: false,
          success: false
        }
      end
    end

    if params[:email]
      unless @user&.valid_password?(params[:password])
        return render json: {
          message: 'Invalid Login Credentials',
          logged_in: false,
          success: false
        }
      end
    end

    if @user and params[:email].present?
      if @user.confirmed_at.nil?
        return render json: {
          message: 'You have to confirm your email address before continuing.',
          logged_in: false,
          success: false
        }
      end
    end

    access_token = @user.generate_access_token

    @user.token = access_token.token
    @user.save(:validate => false)
    if access_token.is_a?(Doorkeeper::AccessToken)
      return render json: {
        access_token: @user.token,
        logged_in: true,
        user: UserSerializer.new(@user, include: [], scope_name: 'current_user')
      }
    end
    render_error_response(access_token)
  end

  def destroy
    doorkeeper_token.destroy
    render_success_response('User Signed out successfully.')
  end

  private

  def set_user
    return unless params[:email].present?

    @user = User.where(email: params[:email]&.downcase).take
    return render_error_response('User not found') unless @user.present?
  end
end
