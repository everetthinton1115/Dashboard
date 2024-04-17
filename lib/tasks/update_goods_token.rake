namespace :campaign do  
  desc 'Update good tokens in escrow'
  task update_goods_token: :environment do
    
    check_in_histories = CampaignCheckInHistory.where(checked_in: true)

    check_in_histories.each do |history|
      history.assign_tokens
      
      if history.tokens.to_i >= 400
        history.update_attributes({
          checked_in: false,
          last_checked_in: nil,
        })
      end
    end
  end
end