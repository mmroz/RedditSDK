//
//  Notifications.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

public extension Notification.Name {
    static let authenticated = Notification.Name("redditsdk.authenticated")
}

public extension Notification {
    static func authenticate(code: String, state: String) -> Notification {
        Notification(name: .authenticated, object: nil, userInfo: ["code": code, "state": state])
    }
}
