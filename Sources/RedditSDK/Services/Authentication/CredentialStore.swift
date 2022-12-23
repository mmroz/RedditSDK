//
//  CredentialStore.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

class CredentialStore {
    private let clientID: String
    
    init(clientID: String) {
        self.clientID = clientID
    }
    
    var grant: AccessGrant? {
        get {
            @KeychainService(account: clientID) var persistedToken : AccessToken?
            guard let secureToken = persistedToken else {
                print("No Token Found")
                return nil
            }
            
            guard secureToken.tombstone > Date() else {
                print("Token expired")
                persistedToken = nil
                return nil
            }
            
            return AccessGrant(
                accessToken: secureToken.accessToken,
                refreshToken: secureToken.refreshToken,
                tokenType: "bearer",
                expiresIn: Int(secureToken.tombstone.timeIntervalSince(Date())),
                scope: secureToken.scope
            )
        }
        set {
            let token: AccessToken?
            if let accessGrant = newValue {
                token = AccessToken(
                    accessToken: accessGrant.accessToken,
                    refreshToken: accessGrant.refreshToken,
                    tombstone: Date(timeIntervalSinceNow: TimeInterval(accessGrant.expiresIn)),
                    scope: accessGrant.scope
                )
            } else {
                token = nil
            }
            @KeychainService(account: clientID) var persistedToken : AccessToken?
            persistedToken = token
        }
    }
}
