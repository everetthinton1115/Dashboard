class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    $smart_contract_server_url = 'https://staging.commitgood.com:3002'
    $smart_contract_production_server_url = 'https://commitgood.com:3002'

    def current_user
        token = request.headers["token"] rescue nil
        User.find_by(token: token) if token.present?
    end

    def authenticate_user
        unless current_user
            render json: {
              success: false,
              message: "Unauthorized request. You need to log in again."
            }, status: 401
        end
    end

    # def authenticate_super_admin_user
    #     puts '!!!!!!!! Authenticate admin user'
    #     if current_user.present? && current_user.super_admin?
    #         true
    #     else
    #         redirect_to root_path and return false
    #     end
    # end
end
