class CampaignCheckInHistory < ApplicationRecord

    def assign_tokens
        time = Time.now - self.last_checked_in
        minutes = time/60
        hours = minutes/60
        
        tokens = self.tokens.to_f
        tokens = tokens + (hours*10)
        
        if tokens <= 400
            self.update_attributes({
                tokens: tokens,
                total_hours: hours
            })
        end
    end
end