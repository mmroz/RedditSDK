//
//  HTTPBody.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

public protocol HTTPBody {
    func encode() throws -> Data
}

public struct FormBody: HTTPBody {
    let values: [String: String]
    
    public init(_ values: [String: String]) {
        self.values = values
    }
    
    public func encode() throws -> Data {
        let pieces = values.map { (key,value) in "\(key)=\(value)" }
        let bodyString = pieces.joined(separator: "&")
        return Data(bodyString.utf8)
    }
}
