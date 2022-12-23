//
//  TrophyList.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public struct TrophyList: Decodable {
    public let kind: String
    public let data: TrophyListData
}

public extension TrophyList {
    struct TrophyListData: Decodable {
        public let trophies: [TrophyData]
    }
    
    struct TrophyData: Decodable {
        public let kind: String
        public let data: Trophy
    }
    
    struct Trophy: Decodable {
        public let icon70: URL
        public let grantedAt: Int
        public let ur: URL?
        public let icon40: URL
        public let name: String
        public let awardId: String?
        public let id: String?
        public let description: String?
    }
}
