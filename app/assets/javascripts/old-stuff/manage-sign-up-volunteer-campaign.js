function signUpVolunteerCampaign(params) {
  const domain = [
    { name: "name", type: "string" },
    { name: "version", type: "string" },
    { name: "chainId", type: "uint256" },
    { name: "verifyingContract", type: "address" },
    { name: "salt", type: "bytes32" }
  ];
  
  const eventSignUpVolunteerCampaign = [
    { name: "volunteer", type: "address" },
    { name: "volunteerId", type: "uint256" },
    { name: "charity", type: "address" },
    { name: "charityId", type: "uint256" },
    { name: "campaignId", type: "uint256" },
    { name: "signer", type: "address" }
  ];

  const domainData = {
    name: "Commit Good",
    version: "1",
    chainId: parseInt(web3.version.network, 10),
    verifyingContract: "0xeecdc5efa97265c38af1038fcd10a959e6b871be", // replace with the test or mainnet address of the smart contract
    salt: uuid.v1()
  }
  const message = {
    volunteer: params.volunteer,
    volunteerId: params.volunteerId,
    charity: params.charity,
    charityId: params.charityId,
    campaignId: params.campaignId,
    signer: App.account
  }
  const data = JSON.stringify({
    types: {
      EIP712Domain: domain,
      EventSignUpVolunteerCampaign: eventSignUpVolunteerCampaign,
    },
    domain: domainData,
    primaryType: "EventSignUpVolunteerCampaign",
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
      await appendMessageQueue(result.result, data, url, {successFunction: {name: 'signupCampaignSuccessful'}});
    }
  });
}
