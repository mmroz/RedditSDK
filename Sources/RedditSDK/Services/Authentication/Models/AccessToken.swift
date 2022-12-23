//
//  AccessToken.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public struct AccessToken: Codable {
    public let accessToken: String
    public let refreshToken: String?
    public let tombstone: Date
    public let scope: String
}
