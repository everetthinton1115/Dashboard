function eventFundsDonatedAction(params, txHash) {
  const domain = [
    { name: "name", type: "string" },
    { name: "version", type: "string" },
    { name: "chainId", type: "uint256" },
    { name: "verifyingContract", type: "address" },
    { name: "salt", type: "bytes32" }
  ];
  
  const eventFundsDonated = [
    { name: "donor", type: "address" },
    { name: "donorId", type: "uint256" },
    { name: "charity", type: "address" },
    { name: "charityId", type: "uint256" },
    { name: "campaignId", type: "uint256" },
    { name: "amount", type: "uint256" },
    { name: "goalReached", type: "bool" },
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
    donor: App.account,
    donorId: params.user_id,
    charity: params.charity,
    charityId: params.charityId,
    campaignId: params.campaignId,
    amount: params.amount,
    goalReached: params.goalReached,
    signer: App.account
  }
  const data = JSON.stringify({
    types: {
      EIP712Domain: domain,
      EventFundsDonated: eventFundsDonated,
    },
    domain: domainData,
    primaryType: "EventFundsDonated",
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
      await appendMessageQueue(result.result, data, url, {successFunction: { name: 'displayContributionMessage', params: {txHash: txHash}}});
    }
  });
}
