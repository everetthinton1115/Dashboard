class Api::MessagesController < Api::BaseController

  include RequestAuthenticationModule

  def append_message
    if primary_keys_valid
      MessageQueueService.append_message(params[:sig], params[:data])
      if params[:campaign_id].present?
        return render json: { id: params[:campaign_id] }
      else
        return render_success_response('Signed transaction message appended to the queue successfully.')
      end
    end
    render_error_response('Bad request.')
  end

end
