//
//  BloctoPolygonSDK.swift
//  BloctoSDK
//
//  Created by Andrew Wang on 2022/5/13.
//

import Foundation

private var associateKey: Void?

extension BloctoSDK {

    public var polygon: BloctoPolygonSDK {
        get {
            if let polygonSDK = objc_getAssociatedObject(self, &associateKey) as? BloctoPolygonSDK {
                return polygonSDK
            } else {
                let polygonSDK = BloctoPolygonSDK(base: self)
                objc_setAssociatedObject(self, &associateKey, polygonSDK, .OBJC_ASSOCIATION_RETAIN)
                return polygonSDK
            }
        }
    }

}

public class BloctoPolygonSDK {

    private let base: BloctoSDK

    init(base: BloctoSDK) {
        self.base = base
    }

    /// To request Polygon account address
    /// - Parameters:
    ///   - completion: completion handler for this methods. Please note this completion might not be called in some circumstances. e.g. SDK version incompatible with Blocto Wallet app.
    ///   The successful result is address String for Polygon.
    public func requestAccount(completion: @escaping (Result<String, Swift.Error>) -> Void) {
        let method = RequestAccountMethod(blockchain: .polygon, callback: completion)
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
            blockchain: .polygon,
            callback: completion)
        base.send(method: method)
    }

    /// To sign transaction and then send transaction
    /// - Parameters:
    ///   - uuid: The id to identify this request, you can pass your owned uuid here.
    ///   - transaction: Custom type EVMBaseTransaction.
    ///   - completion: completion handler for this methods. Please note this completion might not be called in some circumstances. e.g. SDK version incompatible with Blocto Wallet app.
    ///   The successful result is Tx hash of Polygon.
    public func sendTransaction(
        uuid: UUID = UUID(),
        transaction: EVMBaseTransaction,
        completion: @escaping (Result<String, Swift.Error>) -> Void
    ) {
        let method = SendEVMBasedTransactionMethod(
            id: uuid,
            blockchain: .polygon,
            transaction: transaction,
            callback: completion)
        base.send(method: method)
    }

}
