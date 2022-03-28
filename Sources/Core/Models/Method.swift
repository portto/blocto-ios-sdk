//
//  Method.swift
//  Alamofire
//
//  Created by Andrew Wang on 2022/3/14.
//

import Foundation

public protocol Method {
    var id: UUID { get }
    var type: MethodType { get }

    func encodeToURL(baseURLString: String) throws -> URL?
    func resolve(components: URLComponents)
    func handleError(error: Swift.Error)
}
