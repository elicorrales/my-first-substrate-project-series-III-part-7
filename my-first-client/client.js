const { WsProvider, ApiPromise, Keyring } = require('@polkadot/api');
const { ContractPromise } = require('@polkadot/api-contract');
const wsUrl = 'ws://localhost:9944';

let metadataPath = '../my-first-smart-contracts/helloworld/target/ink/metadata.json';
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
