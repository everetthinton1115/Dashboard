async function appendMessageQueue(result, params, url, options = {}) {
  $.ajax({
    method: 'POST',
    url,
    data: {
      sig: result,
      data: params,
      campaign_id: options.campaignId
    }, 
    success: function(data) {
      options.successFunction && options.successFunction.name && window[options.successFunction.name](data, options.successFunction.params);
    }
  });
}

function displayContributionMessage(data = null, options = {}) {
  options.txHash && swal('Thanks for the contribution!', `Your transaction id is: ${options.txHash}`, 'success');
}

function redirectToCampaign(data = null, options = {}) {
  window._events_in_progress == 0 && window.location.replace(`${window.location.protocol}//${window.location.host}/campaigns/${data.id}`);
}

function signupCampaignSuccessful(data = null, options = {}) {
  swal("", "Success", "success");
}

function needContributionSuccessful(data = null, options = {}) {
  swal("", "Success", "success");
}
