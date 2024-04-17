require 'net/http'

class SessionsController < ApplicationController
    def new
        if current_user
			puts "!!!!!!! REDIRECT TO ROOT PATH SC:4"
            redirect_to root_path
        else
            render 'new'
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path
    end

    def create
        if User.find_by_email(params[:user][:email]).present?
            @user = User.find_by_email(params[:user][:email]).try(:confirmed_at).present?
            if @user
                @vaildate_user = User.find_by_email(params[:user][:email])
                # bit_address = @vaildate_user.bitcoin_address
                # eth_address = @vaildate_user.ethereum_address

                # blockio = BlockioApiService.block_io
                # # Validate bitcoin address at API end
                # begin
                #   btc_address_response = blockio.is_valid_address(:address => bit_address)['data']['is_valid']
                #   flash[:error] = 'Error Logging in. If this continues please contact our Support Team.' unless btc_address_response
                # rescue BlockIo::APIException => e
                #   e.raw_data
                # rescue Exception => e
                #   flash[:error] = e
                # end

                # # Validate ethereum address at API end
                # eth_address_response = Faraday.post("#{ENV['CRYPTO_REST_API_V2']}/blockchain-tools/ethereum/mainnet/addresses/validate") do |req|
                #     req.headers['Content-Type'] = 'application/json'
                #     req["X-API-Key"] = "#{ENV['MY_CRYPTO_APIS_KEY']}"
                #     req.body = {
                #         data: {
                #             item: {
                #                 address: eth_address
                #             }
                #         }
                #     }.to_json
                # end
                # #Error if no such ethereum address is present at the API end
                # unless eth_address_response.success? && JSON.parse(eth_address_response.body)['data']['item']['isValid']
                #     puts 'Error Logging into User Wallet API: ', @vaildate_user.email, eth_address_response.body
                #     Rails.logger.error "Error Logging into User Wallet API: #{@vaildate_user.email}, #{eth_address_response.body}"
                #     flash[:error] = 'Error Logging in. If this continues please contact our Support Team.'
                #     redirect_back(fallback_location: root_path)
                #     return
                # end
                if @vaildate_user.valid_password? params[:user][:password]
                    sign_in @vaildate_user
                    session[:user_id] = @vaildate_user.id

					puts "!!!!!!! REDIRECT TO ROOT PATH SC:27"
                    redirect_to root_path
                else
                    flash[:error] = 'Invalid Email or password'
                    redirect_back(fallback_location: root_path)
                end
                # else
                #     flash[:error] = 'Provided credentials are incorrect, please try again.'
                #     redirect_back(fallback_location: root_path)
                # end     
            else
                flash[:error] = "Please Confirm Your Email Address <a href='/request_activation_email/#{params[:user]["email"]}'>Resend</a>"
                redirect_back(fallback_location: root_path)
            end
        else
            flash[:error] = 'Invalid Email or password'
            redirect_back(fallback_location: root_path)
        end
    end
end