//
//  RedditPublicApi.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

enum RedditApi {
    case me(token: String?)
    case karma(token: String?)
    case prefs(token: String?)
    case trophies(token: String?)
}

// MARK: - EndPointType

extension RedditApi: EndPointType {
    var baseURL: URL {
        URL(string: "https://oauth.reddit.com")!
    }
    
    var path: String {
        switch self {
        case .me:
            return "/api/v1/me"
        case .karma:
            return "/api/v1/me/karma"
        case .prefs:
            return "/api/v1/me/prefs"
        case .trophies:
            return "/api/v1/me/trophies"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .me, .karma, .prefs, .trophies:
            return .get
        }
    }
    
    var body: HTTPBody? {
        switch self {
        case .me, .karma, .prefs, .trophies:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .me(token: let token?),
                .karma(token: let token?),
                .prefs(token: let token?),
                .trophies(token: let token?):
            return [ "Authorization": "bearer " + token ]
        default:
            return nil
        }
    }
}
