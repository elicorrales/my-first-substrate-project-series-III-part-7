# my-first-substrate-project-series-III-part-7

### This project is part of a series and includes a video.

See [Here](https://github.com/elicorrales/blockchain-tutorials/blob/main/README.md) for the overall document that
refers to all the series.  
  
# To Talk To The Contract - How About The Contract Promise  
  
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
  
- What is the ```wsApi``` for?  I didn't find extensive docs on this but it's most likely required by the ```ContractPromise``` to actually communicate.  
- What is the ```metadata```?  If you take a look at your smart contract's ```target/ink/metadata.json``` file, that's what we want to pass as the ```metadata``` parameter.  (More on this in a bit).  
- What is the ```contractAddress```?  This is that string that is produced at the end of doing a ```cargo contract instantiate...```.  
  
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
  

# Add The Basic Contract Creation Statement, set Constructor Param Values 
  
Where does the ```...= new ContractPromise(....``` statement go?  
  

Right now, place it like so:  
```
const wsUrl = 'ws://localhost:9944';
const { WsProvider, ApiPromise } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
(async () => {
    let ws = new WsProvider(wsUrl);
    let wApi = await ApiPromise.create({ provider: ws });
    console.log(await wApi.tx);

    //place HERE below
    const contract = new ContractPromise(wsApi, metadata, contractAddress);

    wApi.disconnect();
})();
```
  
How does the above affect running ```client.js``` ?  
  
- Start up your local ```substrate-contracts-node```
- Do ```cargo +nightly contract build``` (so you can have a ```target/ink/metadata.json```)
- Run ```node``` on this ```client.js``` (code below)
- Choose to UN-comment only one of the (TRY #1, TRY #2, TRY #3) to see what happens.

```
const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

//Get the project's complete smart-contract metadata path param so we can get 
//metadata.json's contents.
//Note that this path assumes you ran 'node client.js' while in the actual client.js' directory. 
let metadataPath = '../my-first-smart-contracts/helloworld/target/ink/metadata.json';
//a little sanity check
if (!metadataPath.endsWith('target/ink/metadata.json')) {
    console.log('\n\nFILE metadata.json missing (not built?)');
    console.log('OR WRONG PATH:', metadataPath);
    return;

}

//convert the metadata file constants into local variable
const metadata = require(metadataPath);
//console.log(metadata);

//TRY #1
//let contractAddress = 'thisisaboguscontractaddress';
//Error: createType(AccountId):: Decoding thisisaboguscontractaddress: 
//Invalid decoded address length

//TRY #2
//let contractAddress = 'ThisIsABogusContractAddressUr67MQfgEoUUkrizXVgbz';
//Error: createType(AccountId):: Decoding ThisIsABogusContractAddressUr67MQfgEoUUkrizXVgbz: 
//Invalid base58 character "I" (0x49) at index 4

//TRY #3
//let contractAddress = '5H2EXJWscxyMLjmxKP2KhJmQ6JsUr67MQfgEoUUkrizXVgbz';


(async () => {
    //connect to our local substrate node
    let ws = new WsProvider(wsUrl);
    let wsApi = await ApiPromise.create({ provider: ws });
    const contract = new ContractPromise(wsApi, metadata, contractAddress);
    wsApi.disconnect();
})();
```
  
What did we learn?  We learn that so far, your ```client.js``` does not know whether your contract is actually deployed on to the local node.  
  

