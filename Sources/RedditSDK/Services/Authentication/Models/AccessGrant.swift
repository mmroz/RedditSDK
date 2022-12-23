//
//  AccessGrant.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public struct AccessGrant: Decodable {
    public let accessToken: String
    public let refreshToken: String?
    public let tokenType: String
    public let expiresIn: Int
    public let scope: String
}
