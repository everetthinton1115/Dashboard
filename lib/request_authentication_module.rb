module RequestAuthenticationModule

  def primary_keys_valid
    begin
      parsed_data = JSON.parse(params[:data])
      key_params = parsed_data["message"]
      event_type = parsed_data["primaryType"]
      
      charity = User.find_by_id(key_params["charityId"])
      campaign = Campaign.find_by_id(key_params["campaignId"])

      return false unless charity && campaign

      if event_type == "EventSignUpVolunteerCampaign"
        return false unless Volunteer.find_by_id(key_params["volunteerId"])
      elsif ["EventFundsDonated", "EventInKindDonation"].include?(event_type)
        return false unless User.find_by_id(key_params["donorId"])
      end

      return true
    rescue Exception => e
      return false
    end
    return false
  end

end
