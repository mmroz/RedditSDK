//
//  AuthNetworkingManager.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

class AuthNetworkingManager {
    
    // MARK: - Properties
    
    private let router = Router<RedditAuthApi>()
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Public
    
    func accessToken(clientID: String, grantType: GrantType, code: String, redirectURI: String) async -> Result<AccessGrant, RouterError> {
        let result = await router.request(.accessToken(clientID: clientID, grantType: grantType, code: code, redirectURI: redirectURI))
        return handleResult(result)
    }
    
    func revokeToken(clientID: String, token: String, tokenType: TokenType?) async {
        _ = await router.request(.revokeToken(clientID: clientID, token: token, tokenTypeHint: tokenType))
    }
    
    // MARK: - Private
    
    private func handleResult<D: Decodable>(_ result: Result<Data, RouterError>) -> Result<D, RouterError> where D: Decodable {
        switch result {
        case .success(let data):
            do {
                let access = try jsonDecoder.decode(D.self, from: data)
                return .success(access)
            } catch {
                return .failure(.decodingError(error))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
