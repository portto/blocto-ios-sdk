//
//  BloctoBSCSDK.swift
//  BloctoSDK
//
//  Created by Andrew Wang on 2022/5/13.
//

import Foundation

private var associateKey: Void?

extension BloctoSDK {

    public var bsc: BloctoBSCSDK {
        get {
            if let bscSDK = objc_getAssociatedObject(self, &associateKey) as? BloctoBSCSDK {
                return bscSDK
            } else {
                let bscSDK = BloctoBSCSDK(base: self)
                objc_setAssociatedObject(self, &associateKey, bscSDK, .OBJC_ASSOCIATION_RETAIN)
                return bscSDK
            }
        }
    }

}

public class BloctoBSCSDK {

    private let base: BloctoSDK

    init(base: BloctoSDK) {
        self.base = base
    }

    /// To request Binance Smart Chain account address
    /// - Parameters:
    ///   - completion: completion handler for this methods. Please note this completion might not be called in some circumstances. e.g. SDK version incompatible with Blocto Wallet app.
    ///   The successful result is address String for Binance Smart Chain.
    public func requestAccount(completion: @escaping (Result<String, Swift.Error>) -> Void) {
        let method = RequestAccountMethod(blockchain: .binanceSmartChain, callback: completion)
        base.send(method: method)
    }

    /// To sign message
    /// - Parameters:
    ///   - uuid: The id to identify this request, you can pass your owned uuid here.
    ///   - from: send from which address.
    ///   - message: message needs to be sign in String format.
    ///   - signType: pre-defined signType in BloctoSDK/EVMBase
    ///   - completion: completion handler for this methods. Please note this completion might not be called in some circumstances. e.g. SDK version incompatible with Blocto Wallet app.
    public func signMessage(
        uuid: UUID = UUID(),
        from: String,
        message: String,
        signType: EVMBaseSignType,
        completion: @escaping (Result<String, Swift.Error>) -> Void
    ) {
        let method = SignEVMBaseMessageMethod(
            id: uuid,
            from: from,
            message: message,
            signType: signType,
            blockchain: .binanceSmartChain,
            callback: completion)
        base.send(method: method)
    }

    /// To sign transaction and then send transaction
    /// - Parameters:
    ///   - uuid: The id to identify this request, you can pass your owned uuid here.
    ///   - transaction: Custom type EVMBaseTransaction.
    ///   - completion: completion handler for this methods. Please note this completion might not be called in some circumstances. e.g. SDK version incompatible with Blocto Wallet app.
    ///   The successful result is Tx hash of BSC.
    public func sendTransaction(
        uuid: UUID = UUID(),
        transaction: EVMBaseTransaction,
        completion: @escaping (Result<String, Swift.Error>) -> Void
    ) {
        let method = SendEVMBasedTransactionMethod(
            id: uuid,
            blockchain: .binanceSmartChain,
            transaction: transaction,
            callback: completion)
        base.send(method: method)
    }

}
