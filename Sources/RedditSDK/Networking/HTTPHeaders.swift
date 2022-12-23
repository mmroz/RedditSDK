//
//  HTTPHeaders.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

public typealias HTTPHeaders = [String:String]

extension HTTPHeaders {
    static func basicAuth(username: String, password: String) -> String {
        let loginString = "\(username):\(password)"
        guard let base64Data = loginString.data(using: .utf8)?.base64EncodedData() else {
            fatalError("Could not encode")
        }
        let stringData = String(decoding: base64Data, as: UTF8.self)
        return "Basic " + stringData
    }
    
    static func bearer(_ token: String) -> String {
        "Bearer " + token
    }
    
    static let applicationJson: String =  "application/json"
    static let formEncoding: String = "application/x-www-form-urlencoded; charset=utf-8"
}
