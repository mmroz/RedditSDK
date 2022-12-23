//
//  Keychain.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation
import Security

enum Keychain {
    /// Does a certain item exist?
    static func exists(account: String, service: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: false,
        ] as NSDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            return false
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Adds an item to the keychain.
    private static func add(value: Data, account: String, service: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            // Allow background access:
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
        ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Updates a keychain item.
    private static func update(value: Data, account: String, service: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
        ] as NSDictionary, [
            kSecValueData: value,
        ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Stores a keychain item.
    static func set(value: Data, account: String, service: String) throws {
        if try exists(account: account, service: service) {
            try update(value: value, account: account, service: service)
        } else {
            try add(value: value, account: account, service: service)
        }
    }
    
    // If not present, returns nil. Only throws on error.
    static func get(account: String, service: String) throws -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true,
        ] as NSDictionary, &result)
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Delete a single item.
    static func delete(account: String, service: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
        ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Delete all items for my app. Useful on eg logout.
    static func deleteAll() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
        ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    enum Errors: Error {
        case keychainError
    }
}
