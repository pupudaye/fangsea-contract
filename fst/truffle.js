var HDWalletProvider = require("truffle-hdwallet-provider");

// infura 注册后获取的api-key
var infura_apikey = "402563c7049a4cecb66657952ca4edf4";

// 你的以太坊钱包地址 進入 MetaMask -> Settings -> reveal seed words 复制到这里
var mnemonic = "amount jungle flower jelly puzzle behind bulk steak disease burden bundle worth";

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 9545,
            network_id: "*",// Match any network id
            // gas: 210000
        },
        private: {
            host: "localhost",
            port: 8545,
            network_id: "*" // Match any network id
        },
        ropsten: {
            provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/"+infura_apikey),
            network_id: 3,
            gas: 3012388,
            gasPrice: 30000000000
        },
        main: {
            provider: new HDWalletProvider(mnemonic, "https://mainnet.infura.io/"+infura_apikey),
            network_id: 3,
            gas: 3012388,
            gasPrice: 1000000000
        }
    },
    mocha: {
        useColors: true
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
