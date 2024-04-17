var instance;

App = {
  web3Provider: null,
  contracts: {},
  account: "0x0",
  hasVoted: false,

  start: async function () {
    App.initWeb3();
    await App.initContract();
  },

  initWeb3: function () {
    web3 = new Web3(window.web3.currentProvider)
    App.account = web3.eth.coinbase
  },

  initContract: async function () {
    const contract = await web3.eth.contract(CommitGoodToken.abi)
    instance = await contract.at(CommitGoodToken.address)
  },


  transferTokens: async function (data) {
    const amount = $('#campaign_donation_donation_amount').val() * 1e18;
    const toAddress = $('#campaign_donation_charity_wallet_address').val();
    instance.balanceOf(App.account, (err, res) => {
      if (err) {
        swal('Could not complete transaction', 'Please try again', 'error');
      } else {
        if (+res < amount) {
          swal('Could not complete transaction', 'Not enough balance', 'error');
        } else {
          instance.transfer.sendTransaction(toAddress, amount, {
            from: App.account
          }, (error, txHash) => {
            if (error) {
              swal('Could not complete transaction', 'Please try again', 'error');
            } else {
              data.toAddress = toAddress;
              eventFundsDonatedAction(data, txHash);
            }
            $('#donateModal').modal('toggle');
            $('#campaign_donation_donation_amount').val('');
          });
        }
      }
    })
  }
};

$(function () {
  $(window).load(function () {
    App.start();
  });
});
