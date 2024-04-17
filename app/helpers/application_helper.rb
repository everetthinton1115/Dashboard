module ApplicationHelper

  def calculate_volunteer_hours
    CampaignCheckInHistory.where(user_id: current_user.id, redeem_at: nil).pluck(:total_hours).sum(&:to_f)
  end
  def check_reward_percentage(campaign)
    ((campaign.transactions.sum(:amount_in_usd) / campaign.goal_amount) * 100).to_f > 10.0 rescue false
  end

  def image_url(url)
		if url.split('system')[1]
			"https://s3.amazonaws.com/" + ENV['S3_BUCKET'].to_s + url.split('system')[1].to_s
		end
  end

  def load_image(object)
    object.try(:exists?) ? object.url : "/assets/missing-120720.png"
  end

	def embed_from_youtube_url(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
	    youtube_id = $1
	  else
	    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    youtube_id = $5
	  end
	  if youtube_id.present?
    	content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}")
    end
  end

  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

  def referral_validity(referral)
    if referral.present?
        @referral = Invite.where(referral_code: referral)
      if @referral.present?
         @referral = User.where(referral_code: referral).present?
          return @referral
      else
        @referral = true
      end
    else
      @referral = false
    end
  end

    def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end
end
