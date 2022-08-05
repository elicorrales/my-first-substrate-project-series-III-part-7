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
  

# How does the above affect running ```client.js``` ?  
  
- Start up your local ```substrate-contracts-node```
- Run ```node``` on this ```client.js``` (code below)
- Choose to UN-comment only one of the (TRY #1, TRY #2, TRY #3) to see what happens.

```
const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

const metadata = '{}';

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
//This works just fine.

(async () => {
    //connect to our local substrate node
    let ws = new WsProvider(wsUrl);

    //wsApi
    let wsApi = await ApiPromise.create({ provider: ws });
    const contract = new ContractPromise(wsApi, metadata, contractAddress);

    //tempApi
    //let tempApi = new ApiPromise();
    //const contract = new ContractPromise(tempApi, metadata, contractAddress);

    wsApi.disconnect();
})();
```
  

#### What did we learn?
As of now, ```client.js```:
- does perform some checks on the ```contractAddress```, but
- does not know whether your contract is actually deployed on to the local node
- does not care too much about ```metadata```
  


# What Are the Effects of the 1st Param ```wsApi```?  
  
Next, comment out both of the lines under ```//wsApi```, and Uncomment both under ```//tempApi```.  
  

Run ```node client.js``` (code below)
```
const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

const metadata = '{}';

let contractAddress = '5H2EXJWscxyMLjmxKP2KhJmQ6JsUr67MQfgEoUUkrizXVgbz';

(async () => {
    //connect to our local substrate node
    let ws = new WsProvider(wsUrl);

    //wsApi
    //let wsApi = await ApiPromise.create({ provider: ws });
    //const contract = new ContractPromise(wsApi, metadata, contractAddress);

    //tempApi
    let tempApi = new ApiPromise(); <-- more on this further down
    const contract = new ContractPromise(tempApi, metadata, contractAddress);
    //ERROR:
    // Your API has not been initialized correctly and is not connected to a chain

    wsApi.disconnect();
})();
```
  

#### What did we learn?
As of now, ```client.js```:
- Where it failed was inside the creation (```new ContractPromise(...blah .)```
- It did NOT fail on the creation of ```tempApi```
- There **was** some checking done to see if it's a live connection to the contracts node
  

# What Some Effects Of The 2nd Param ```metadata```?  
Next, add the following:  
```
    console.log('query:\n', contract.query);
    console.log('tx:\n', contract.tx);
```
  

Run ```node client.js``` (code below)  
```
const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

const metadata = '{}';

let contractAddress = '5H2EXJWscxyMLjmxKP2KhJmQ6JsUr67MQfgEoUUkrizXVgbz';

(async () => {
    //connect to our local substrate node
    let ws = new WsProvider(wsUrl);

    wsApi
    let wsApi = await ApiPromise.create({ provider: ws });
    const contract = new ContractPromise(wsApi, metadata, contractAddress);

    console.log('query:\n', contract.query);
    console.log('tx:\n', contract.tx);

    wsApi.disconnect();
})();
```
  
The output:  
```
query:
 {}
tx:
 {}
```
  

#### What did we learn?
- ```contract.query``` is a thing. It's valid. But empty.
- ```contract.tx``` is also a valid thing. But empty.
  

Remember we have two empty JSON responses, so we can compare to what's next (below).  
  
Now, let's make ```metadata``` be something real.  
  

We add:
```
//Get the project's complete smart-contract metadata path param so we can get 
//metadata.json's contents.
//make sure that YOUR path is correct; it may be different from (below).
//This relative path assumes you did 'node client.js' within the client project directory.
// It assumes this tree:
//
// .(our top-level overall project)
// |
// |__my-first-client/  <-- we ran 'node client.js' while in here
// |      |__client.js
// |
// |__my-first-smart-contracts/
//        |__helloworld/
//
let metadataPath = '../my-first-smart-contracts/helloworld/target/ink/metadata.json';

//a little sanity check
if (!metadataPath.endsWith('target/ink/metadata.json')) {
    console.log('\n\nFILE metadata.json missing (not built?)');
    console.log('OR WRONG PATH:', metadataPath);
    return;

}

const metadata = require(metadataPath);
```
  
Run ```node client.js``` (code below)  
```
const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

//lots of comments here snipped out
let metadataPath = '../my-first-smart-contracts/helloworld/target/ink/metadata.json';

//a little sanity check
if (!metadataPath.endsWith('target/ink/metadata.json')) {
    console.log('\n\nFILE metadata.json missing (not built?)');
    console.log('OR WRONG PATH:', metadataPath);
    return;

}

//const metadata = '{}';

//convert the metadata file constants into local variable
const metadata = require(metadataPath);

let contractAddress = '5H2EXJWscxyMLjmxKP2KhJmQ6JsUr67MQfgEoUUkrizXVgbz';

(async () => {
    //connect to our local substrate node
    let ws = new WsProvider(wsUrl);

    let wsApi = await ApiPromise.create({ provider: ws });
    const contract = new ContractPromise(wsApi, metadata, contractAddress);

    console.log('query:\n', contract.query);
    console.log('tx:\n', contract.tx);

    wsApi.disconnect();
})();
```
  
The output:  
```
query:
 {
  sayhello: [Function (anonymous)] {
    .....stuff snipped from here...
  },
  saybye: [Function (anonymous)] {
    .....stuff snipped from here...
  }
}
tx:
 {
  sayhello: [Function (anonymous)] {
    .....stuff snipped from here...
  },
  saybye: [Function (anonymous)] {
    .....stuff snipped from here...
  }
}
```
  

#### What did we learn?
As of now, ```client.js```:
- The contents of the external file ```metadata.json``` are used for ```query``` and ```tx```.
  
But so what.  
What effect does that have.  
We'll see as we move along.  

# We Finally Let's Try To Interact With The Contract
  
Make sure you have:
- built the contract
- are running the local node(blockchain)
- have uploaded the contract
- have instantiated the contract
  

In order to do a transaction with the contract, someone has to pay for it.  
  
So we'll get ```//Alice``` to pay for it.  
  
 
