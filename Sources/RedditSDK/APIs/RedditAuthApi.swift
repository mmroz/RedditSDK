//
//  RedditAuthApi.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

enum RedditAuthApi {
    case accessToken(clientID: String, grantType: GrantType, code: String, redirectURI: String)
    case refreshToken(clientID: String, grantType: GrantType, refreshToken: String)
    case revokeToken(clientID: String, token: String, tokenTypeHint: TokenType?)
}

// MARK: - EndPointType

extension RedditAuthApi: EndPointType {
    var baseURL: URL {
        URL(string: "https://www.reddit.com")!
    }
    
    var path: String {
        switch self {
        case .accessToken, .refreshToken:
            return "/api/v1/access_token"
        case .revokeToken:
            return "/api/v1/revoke_token"
        }
    }
    
    var httpMethod: HTTPMethod {
        .post
    }
    
    var body: HTTPBody? {
        switch self {
        case .accessToken(clientID: _, grantType: let grantType, code: let code, redirectURI: let redirectURI):
            return FormBody([
                "grant_type": grantType.rawValue,
                "code": code,
                "redirect_uri": redirectURI
            ])
        case .refreshToken(clientID: _, grantType: let grantType, refreshToken: let refreshToken):
            return FormBody([
                "grant_type": grantType.rawValue,
                "refresh_token": refreshToken
            ])
        case .revokeToken(clientID: _, token: let token, tokenTypeHint: let tokenTypeHint?):
            return FormBody([
                "token": token,
                "token_type_hint": tokenTypeHint.rawValue
            ])
        case .revokeToken(clientID: _, token: let token, tokenTypeHint: nil):
            return FormBody([
                "token": token,
            ])
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .accessToken(let clientID, _, _, _),
                .refreshToken(let clientID, _, _),
                .revokeToken(let clientID, _, _):
            return  [
                "Authorization" : HTTPHeaders.basicAuth(username: clientID, password: ""),
                "Content-Type": HTTPHeaders.formEncoding
            ]
        }
    }
}
