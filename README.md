# my-first-substrate-project-series-III-part-7

### This project is part of a series and includes a video.

See [Here](https://github.com/elicorrales/blockchain-tutorials/blob/main/README.md) for the overall document that
refers to all the series.  
  
# To Talk To The Contract - Contract Promise  
  

This version of ```client.js```...  
```
const wsUrl = 'ws://localhost:9944';
const { WsProvider, ApiPromise } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
(async () => {
    let ws = new WsProvider(wsUrl);
    let wApi = await ApiPromise.create({ provider: ws });
    console.log(await wApi.tx);
    wApi.disconnect();
})();
```
  
....can interact with the ```substrate-contracts-node```, but to make our lives easier, we may want to use the ```ContractPromise```.  
  
```
    const contract = new ContractPromise(wsApi, metadata, contractAddress);
```
  
What is the ```wsApi``` for?  I didn't find extensive docs on this but it's most likely required by the ```ContractPromise``` to actually communicate.  
What is the ```metadata``?  If you take a look at your smart contract's ```target/ink/metadata.json``` file, that's what we want to pass as the ```metadata``` parameter.  (More on this in a bit).  
What is the ```contractAddress```?  This is that string that is produced at the end of doing a ```cargo contract instantiate...```.  
Sample:  
```  
cargo contract instantiate......


        Event Balances ➜ Withdraw
          who: 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY
          amount: 86298152

   ..... lot's of output here snipped out for clarity....

        Event System ➜ ExtrinsicSuccess
          dispatch_info: DispatchInfo { weight: 1050433960, class: Normal, pays_fee: Yes }

     Contract 5E6bT6Uq1DXyfao1yBNPXUMYTWpQqTWX6H15AyMZ6YrQgWR5 <---- THIS is the contractAddress
```
  

