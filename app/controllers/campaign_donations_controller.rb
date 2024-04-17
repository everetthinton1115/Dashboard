class CampaignDonationsController < ApplicationController

  def create
    donation_amount = params[:campaign_donation][:donation_amount].to_f
    symbol = ''
    charity_wallet_address = ''
    charity_coordinator_address = ''
    grand_total_amount = ''
    @campaign = Campaign.find(params[:campaign_id])
    if donation_amount.present? && params[:btc_currency].present?
      commit_good_amount = BigDecimal((donation_amount*7/100).to_s).truncate(8).to_s('F')
      charity_coordinator_amount = BigDecimal((donation_amount*1/100).to_s).truncate(8).to_s('F')
      charity_amount = donation_amount - (commit_good_amount.to_f + charity_coordinator_amount.to_f)
      symbol = 'btc'
      current_user_address = current_user.bitcoin_address
      charity_wallet_address = @campaign.user.try(:bitcoin_address)
      charity_coordinator_address = User.find(@campaign.campaign_coordinator_id).try(:bitcoin_address)
      grand_total_amount = params[:btc_grand_total_amount]
    elsif donation_amount.present? && params[:good_currency].present?
      charity_coordinator_amount = BigDecimal((donation_amount*1/100).to_s).truncate(8).to_s('F')
      charity_amount = donation_amount - charity_coordinator_amount.to_f
      symbol = 'good'
      current_user_address = current_user.ethereum_address
      charity_wallet_address = @campaign.user.try(:commit_good_address)
      charity_coordinator_address = User.find(@campaign.campaign_coordinator_id).try(:commit_good_address)
      grand_total_amount = params[:eth_grand_total_amount]
    end

    send_to_charity_amount_response = CampaignDonation.send_transaction(current_user_address, symbol, charity_wallet_address, charity_amount)
    error_in_transaction = false
    error_in_transaction = true if (symbol == 'good' && JSON.parse(send_to_charity_amount_response.body).key?('error')) || (symbol == 'btc' && send_to_charity_amount_response.key?('error'))

    if error_in_transaction
      puts 'Error Send Transaction API: ', current_user.email, send_to_charity_amount_response.body if symbol == 'good'
      Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_to_charity_amount_response.body}" if symbol == 'good'
      # redirect to campaign show page with error message and return
      redirect_to campaign_path(params[:campaign_id]),
        notice: {
                  danger:
                    if symbol == 'good'
                      JSON.parse(send_to_charity_amount_response.body)['error']['message']
                    elsif symbol == 'btc'
                      send_to_charity_amount_response['error']
                    end
                }
      return
    end

    if params[:btc_currency].present? && !(error_in_transaction)
      send_to_commit_good_amount_response = CampaignDonation.send_transaction(current_user_address, symbol, '32J7xF81m7fFB3eBr7jiRgBHT7qj4QmCbn', commit_good_amount)
      if send_to_commit_good_amount_response.key?('error')
        PendingDonation.create(authorization_token: current_user.authorization_token, symbol: symbol, address: '32J7xF81m7fFB3eBr7jiRgBHT7qj4QmCbn', amount: commit_good_amount)
        puts 'Error Send Transaction API: ', current_user.email, send_to_commit_good_amount_response['error']
        Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_to_commit_good_amount_response['error']}"
        flash[:error] = 'Error Transaction. For Commit Good.'
      end
    end

    unless error_in_transaction
      send_to_charity_coordinator_amount_response = CampaignDonation.send_transaction(current_user_address, symbol, charity_coordinator_address, charity_coordinator_amount)
      if (symbol == 'good' && JSON.parse(send_to_charity_coordinator_amount_response.body).key?('error')) || (symbol == 'btc' && send_to_charity_coordinator_amount_response.key?('error'))
        PendingDonation.create(authorization_token: current_user.authorization_token, symbol: symbol, address: charity_coordinator_address, amount: charity_coordinator_amount)
        puts 'Error Send Transaction API: ', current_user.email, send_to_charity_coordinator_amount_response.body if symbol == 'good'
        Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_to_charity_coordinator_amount_response.body}" if symbol == 'good'
        Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_to_charity_coordinator_amount_response['error']}" if symbol == 'btc'
        flash[:error] = 'Error Transaction. For Charity Coordinator.'
      end
    end

    unless error_in_transaction
      PaymentMailer.charity_reciept(@campaign, symbol, charity_amount).deliver_now
      PaymentMailer.doner_reciept(current_user, @campaign, symbol, donation_amount, grand_total_amount.to_f).deliver_now
    end

    @campaign_donation = @campaign.campaign_donations.new(campaign_donation_params)
    if @campaign_donation.valid? && !(error_in_transaction)
      if symbol == 'btc'
        if @campaign.total_amount.present?
          @campaign.total_amount += charity_amount || 0
        else
          @campaign.total_amount = charity_amount || 0
        end
      else
        if @campaign.total_good_amount.present?
          @campaign.total_good_amount += charity_amount || 0
        else
          @campaign.total_good_amount = charity_amount || 0
        end
      end
      @campaign_donation.charity_amount = charity_amount
      @campaign_donation.charity_coordinator_amount = charity_coordinator_amount.to_f
      @campaign_donation.symbol = symbol
      @campaign_donation.campaign_coordinator_id = @campaign.campaign_coordinator_id
      @campaign_donation.charity_id = @campaign.user_id
      @campaign_donation.save
      @campaign.save
      # redirect to campaign show page with success message
      redirect_to campaign_path(params[:campaign_id]), notice: { success: "Thanks for the contribution!" }
    else
      # redirect to campaign show page with error message
      redirect_to campaign_path(params[:campaign_id]), notice: { danger: @campaign_donation.errors.full_messages }
    end
  end

  private
  def campaign_donation_params
    params.require(:campaign_donation).permit(:email, :user_id, :campaign_id, :donation_amount, :card_token, :charge_id, :message)
  end
end
