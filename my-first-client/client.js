const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

//you can get this from the substrate-contracts-node:
// DO: substrate-contracts-node key inspect //Alice
const aliceAddress = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';

let metadataPath = '../my-first-smart-contracts/helloworld/target/ink/metadata.json';

//convert the metadata file constants into local variable
const metadata = require(metadataPath);

//make sure this is YOUR uploaded/instantiated contract address.
let contractAddress = '5CfQobR3ePUTKNn84VzxhgwppFtYQBHwtKD39unAvvYqrM6M';

(async () => {
    //connect to our local substrate node
    let ws = new WsProvider(wsUrl);

    let wsApi = await ApiPromise.create({ provider: ws });
    const contract = new ContractPromise(wsApi, metadata, contractAddress);

    //console.log('query:\n', contract.query);
    //console.log('tx:\n', contract.tx);

    const gasLimit = -1;
    const { result, output } = await contract.query.sayhello(aliceAddress, { gasLimit });
    console.log('result:', result.toHuman());
    console.log('out:', output != undefined ? output.toHuman() : null);

    wsApi.disconnect();
})();
