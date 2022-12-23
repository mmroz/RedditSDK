//
//  GrantType.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public enum GrantType: String {
    case authorizationCode = "authorization_code"
    case refreshToken = "refresh_token"
    case password
}
