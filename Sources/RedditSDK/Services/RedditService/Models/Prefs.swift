//
//  Prefs.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public struct AccountPreferences: Decodable {
    public let beta: Bool
    public let defaultThemeSr: String?
    public let threadedMessages: Bool
    public let emailCommentReply: Bool
    public let privateFeeds: Bool
    public let activityRelevantAds: Bool
    public let emailMessages: Bool
    public let profileOptOut: Bool
    public let videoAutoplay: Bool
    public let emailPrivateMessage: Bool
    public let geopopular: String
    public let showLinkFlair: Bool
    public let hideUps: Bool
    public let showTrending: Bool
    public let sendWelcomeMessages: Bool
    public let countryCode: String
    public let designBeta: Bool
    public let monitorMentions: Bool
    public let hideDowns: Bool
    public let clickgadget: Bool
    public let lang: String
    public let ignoreSuggestedSort: Bool
    public let showPresence: Bool
    public let emailUpvoteComment: Bool
    public let emailDigests: Bool
    public let layout: String
    public let whatsappCommentReply: Bool
    public let numComments: Int
    public let feedRecommendationsEnabled: Bool
    public let labelNsfw: Bool
    public let research: Bool
    public let useGlobalDefaults: Bool
    public let showSnoovatar: Bool
    public let over18: Bool
    public let legacySearch: Bool
    public let liveOrangereds: Bool
    public let highlightControversial: Bool
    public let noProfanity: Bool
    public let domainDetails: Bool
    public let collapseLeftBar: Bool
    public let emailCommunityDiscovery: Bool
    public let badCommentAutocollapse: String
    public let liveBarRecommendationsEnabled: Bool
    public let thirdPartyDataPersonalizedAds: Bool
    public let emailChatRequest: Bool
    public let allowClicktracking: Bool
    public let hideFromRobots: Bool
    public let showTwitter: Bool
    public let compress: Bool
    public let acceptPms: String
    public let storeVisits: Bool
    public let threadedModmail: Bool
    public let emailUpvotePost: Bool
    public let minLinkScore: Int
    public let mediaPreview: String
    public let emailUserNewFollower: Bool
    public let nightmode: Bool
    public let enableDefaultThemes: Bool
    public let thirdPartySiteDataPersonalizedContent: Bool
    public let thirdPartySiteDataPersonalizedAds: Bool
    public let surveyLastSeenTime: Int?
    public let showStylesheets: Bool
    public let enableFollowers: Bool
    public let emailNewUserWelcome: Bool
    public let publicVotes: Bool
    public let emailPostReply: Bool
    public let collapseReadMessages: Bool
    public let showFlair: Bool
    public let markMessagesRead: Bool
    public let searchIncludeOver18: Bool
    public let hideAds: Bool
    public let thirdPartyPersonalizedAds: Bool
    public let emailUsernameMention: Bool
    public let topKarmaSubreddits: Bool
    public let newwindow: Bool
    public let numsites: Int
    public let minCommentScore: Int
    public let sendCrosspostMessages: Bool
    public let media: String
    public let publicServerSeconds: Bool
    public let showGoldExpiration: Bool
    public let highlightNewComments: Bool
    public let emailUnsubscribeAll: Bool
    public let defaultCommentSort: String
    public let showLocationBasedRecommendations: Bool
}
