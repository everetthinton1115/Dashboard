namespace :campaing do  
  desc 'store campaing winner each month'
  task campaign_winner: :environment do
    start_month = Time.now.beginning_of_month - 1.month
    end_month = Time.now.end_of_month - 1.month
    @campaign = Campaign.where("expiration_date > ? AND expiration_date < ?", Time.now.beginning_of_month - 1.month, Time.now.end_of_month - 1.month)
    @campaing_winner = @campaign.joins(:votes).group("campaigns.id").order("count(campaigns.id) ASC").count
    @campaing_winner.values.sort.last
    highest = @campaing_winner.values.sort.last
    @winner_campaign = @campaing_winner.map{|k,v| k if v==highest}.compact
    @winner_campaign.each do |campaign_id|
      campaign = Campaign.find(campaign_id)
      votes = campaign.votes.count
      @winner = campaign.campaign_winners.new(user_id: campaign.user_id, votes: votes, winnig_month: start_month)
      @winner.save
    end
  end
end