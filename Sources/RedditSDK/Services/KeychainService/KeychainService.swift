//
//  KeychainService.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

@propertyWrapper struct KeychainService<Value: Codable> {
    let account: String
    let service: String = "reddit-sdk"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var wrappedValue: Value? {
        get {
            guard
                let data = try? Keychain.get(account: account, service: service),
                let value = try? decoder.decode(Value.self, from: data)
            else {
                return nil
            }
            return value
        }
        set {
            guard let value = newValue else {
                try? Keychain.delete(account: account, service: service)
                return
            }
            guard let encodedData = try? encoder.encode(value) else {
                return
            }
            try? Keychain.set(value: encodedData, account: account, service: service)
        }
    }
}
