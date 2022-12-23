//
//  Account.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public struct Account: Codable {
    public let isEmployee: Bool
    public let isMod: Bool
    public let verified: Bool
    public let coins: Int
    public let id: String
    public let name: String
    public let canCreateSubreddit: Bool
    public let over18: Bool
    public let isGold: Bool
    public let awarderKarma: Int
    public let isSuspended: Bool
    public let iconImage: URL?
    public let inboxCount: Int
    public let linkKarma: Int
    public let totalKarma: Int
    public let seenLayoutSwitch: Bool
    public let hasVisitedNewProfile: Bool
    public let prefNoProfanity: Bool
    public let hasExternalAccount: Bool
    public let prefGeopopular: String
    public let seenRedesignModal: Bool
    public let prefShowTrending: Bool
}
