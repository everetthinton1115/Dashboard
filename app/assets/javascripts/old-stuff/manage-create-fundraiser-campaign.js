function createFundRaiserCampaign(params) {
  const domain = [
    { name: "name", type: "string" },
    { name: "version", type: "string" },
    { name: "chainId", type: "uint256" },
    { name: "verifyingContract", type: "address" },
    { name: "salt", type: "bytes32" }
  ];
  
  const eventCreateFundRaiserCampaign = [
    { name: "charity", type: "address" },
    { name: "charityId", type: "uint256" },
    { name: "campaignId", type: "uint256" },
    { name: "goal", type: "uint256" },
    { name: "signer", type: "address" }
  ];

  const domainData = {
    name: "Commit Good",
    version: "1",
    chainId: parseInt(web3.version.network, 10),
    verifyingContract: "0x039530eb443d7a3baec59403ef46ff4299ac8941", // replace with the test or mainnet address of the smart contract
    salt: uuid.v1()
  }
  const message = {
    charity: params.charity,
    charityId: params.charityId,
    campaignId: params.campaignId,
    goal: params.goal,
    signer: App.account
  }
  const data = JSON.stringify({
    types: {
      EIP712Domain: domain,
      EventCreateFundRaiserCampaign: eventCreateFundRaiserCampaign,
    },
    domain: domainData,
    primaryType: "EventCreateFundRaiserCampaign",
    message: message
  });
  const signer = App.account;
  web3.currentProvider.sendAsync({
    method: "eth_signTypedData_v3",
    params: [signer, data],
    from: signer
  }, async function(err, result) {
    if (err) {
      swal('Could not sign the transaction', 'Please try again', 'error');
    } else {
      const url = `/append_message`
      window._events_in_progress = window._events_in_progress - 1;
      await appendMessageQueue(result.result, data, url, {successFunction: {name: 'redirectToCampaign'}, campaignId: params.campaignId});
    }
  });
}
