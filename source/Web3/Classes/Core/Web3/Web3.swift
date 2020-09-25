//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct Web3 {

    public typealias Web3ResponseCompletion<Result: Codable> = (_ resp: Web3Response<Result>) -> Void
    public typealias BasicWeb3ResponseCompletion = Web3ResponseCompletion<EthereumValue>

    public static let jsonrpc = "2.0"

    // MARK: - Properties

    public let properties: Properties
    

    public struct Properties {
        public let provider: Web3Provider
        public let rpcId: Int
        public let chainId: String
        public let hrp: String
    }

    // MARK: - Convenient properties

    public var provider: Web3Provider {
        return properties.provider
    }

    public var rpcId: Int {
        return properties.rpcId
    }
    
    public var chainId: String {
        return properties.chainId
    }

    /// The struct holding all `net` requests
    public let net: Net

    /// The struct holding all `eth` requests
    public let platon: Platon
    
    /// The struct holding all `staking` contract requests
    public let staking: StakingContract
    
    /// The struct holding all `proposal` contract requests
    public let proposal: ProposalContract
    
    /// The struct holding all `slash` contract requests
    public let slash: SlashContract
    
    /// The struct holding all `restricting` contract requests
    public let restricting: RestrictingPlanContract

    public let reward: RewardContract

    // MARK: - Initialization

    /// Initializes a new instance of `Web3` with the given custom provider.
    /// - Parameters:
    ///   - provider: The provider which handles all requests and responses.
    ///   - rpcId: The rpc id to be used in all requests. Defaults to 1.
    ///   - chainId: chainId
    ///   - hrp: hrp, . Defaults to atx.
    public init(provider: Web3Provider, rpcId: Int = 1, chainId: String, hrp: String = "atx") {
        let properties = Properties(provider: provider, rpcId: rpcId, chainId: chainId, hrp: hrp)
        self.properties = properties
        self.net = Net(properties: properties)
        self.platon = Platon(properties: properties)

        self.staking = StakingContract(platon: self.platon, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: PlatonConfig.ContractAddress.stakingContractAddress))
        self.proposal = ProposalContract(platon: self.platon, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: PlatonConfig.ContractAddress.proposalContractAddress))
        self.slash = SlashContract(platon: self.platon, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: PlatonConfig.ContractAddress.slashContractAddress))
        self.restricting = RestrictingPlanContract(platon: self.platon, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: PlatonConfig.ContractAddress.restrictingContractAddress))
        self.reward = RewardContract(platon: self.platon, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: PlatonConfig.ContractAddress.rewardContractAddress))
    }

    // MARK: - Web3 methods

    /**
     * Returns the current client version.
     *
     * e.g.: "Mist/v0.9.3/darwin/go1.4.1"
     *
     * - parameter response: The response handler. (Returns `String` - The current client version)
     */
    public func clientVersion(response: @escaping Web3ResponseCompletion<String>) {
        let req = BasicRPCRequest(id: rpcId, jsonrpc: type(of: self).jsonrpc, method: "web3_clientVersion", params: [])

        provider.send(request: req, response: response)
    }

    // MARK: - Net methods

    public struct Net {

        public let properties: Properties

        /**
         * Returns the current network id (chain id).
         *
         * e.g.: "1" - Ethereum Mainnet, "2" - Morden testnet, "3" - Ropsten Testnet
         *
         * - parameter response: The response handler. (Returns `String` - The current network id)
         */
        public func version(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_version", params: [])

            properties.provider.send(request: req, response: response)
        }

        /**
         * Returns number of peers currently connected to the client.
         *
         * e.g.: 0x2 - 2
         *
         * - parameter response: The response handler. (Returns `EthereumQuantity` - Integer of the number of connected peers)
         */
        public func peerCount(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_peerCount", params: [])

            properties.provider.send(request: req, response: response)
        }
    }

    // MARK: - Eth methods

    public struct Platon {

        public let properties: Properties
        
        // MARK: - Methods
        public func getSchnorrNIZKProve(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "admin_getSchnorrNIZKProve",
                params: [])
            properties.provider.send(request: req, response: response)
        }

        public func getProgramVersion(response: @escaping Web3ResponseCompletion<ProgramVersion>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "admin_getProgramVersion",
                params: [])
            properties.provider.send(request: req, response: response)
        }

        public func protocolVersion(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_protocolVersion",
                params: []
            )

            properties.provider.send(request: req, response: response)
        }

        public func syncing(response: @escaping Web3ResponseCompletion<EthereumSyncStatusObject>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "platon_syncing", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func gasPrice(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "platon_gasPrice", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func accounts(response: @escaping Web3ResponseCompletion<[EthereumAddress]>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "platon_accounts", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func blockNumber(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_blockNumber",
                params: []
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBalance(
            address: EthereumAddress,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getBalance",
                params: [address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getStorageAt(
            address: EthereumAddress,
            position: EthereumQuantity,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getStorageAt",
                params: [address, position, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionCount(
            address: EthereumAddress,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
            ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getTransactionCount",
                params: [address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockTransactionCountByHash(
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getBlockTransactionCountByHash",
                params: [blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockTransactionCountByNumber(
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getBlockTransactionCountByNumber",
                params: [block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getCode(
            address: EthereumAddress,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getCode",
                params: [address, block]
            )

            properties.provider.send(request: req, response: response)
        }
        
        public func sendTransaction(
            transaction: EthereumTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            guard transaction.from != nil else {
                let error = Web3Response<EthereumData>(error: .requestFailed(nil))
                response(error)
                return
            }
            let req = RPCRequest<[EthereumTransaction]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_sendTransaction",
                params: [transaction]
            )
            properties.provider.send(request: req, response: response)
        }

        public func sendRawTransaction(
            transaction: EthereumSignedTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_sendRawTransaction",
                params: [transaction.rlp()]
            )

            properties.provider.send(request: req, response: response)
        }

        public func call(
            call: EthereumCall,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = RPCRequest<EthereumCallParams>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_call",
                params: EthereumCallParams(call: call, block: block)
            )

            properties.provider.send(request: req, response: response)
        }

        public func estimateGas(call: EthereumCall, response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = RPCRequest<[EthereumCall]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_estimateGas",
                params: [call]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockByHash(
            blockHash: EthereumData,
            fullTransactionObjects: Bool,
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getBlockByHash",
                params: [blockHash, fullTransactionObjects]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockByNumber(
            block: EthereumQuantityTag,
            fullTransactionObjects: Bool,
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getBlockByNumber",
                params: [block, fullTransactionObjects]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByHash(
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getTransactionByHash",
                params: [blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByBlockHashAndIndex(
            blockHash: EthereumData,
            transactionIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getTransactionByBlockHashAndIndex",
                params: [blockHash, transactionIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByBlockNumberAndIndex(
            block: EthereumQuantityTag,
            transactionIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getTransactionByBlockNumberAndIndex",
                params: [block, transactionIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionReceipt(
            transactionHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumTransactionReceiptObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "platon_getTransactionReceipt",
                params: [transactionHash]
            )

            properties.provider.send(request: req, response: response)
        }
    }
}
