//
//  RedditNetworkManager.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

class RedditNetworkManager {
    
    // MARK: - Properties
    
    private let router = Router<RedditApi>()
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Public Properties
    
    var accessToken: String?
    
    // MARK: - Public
    
    func me() async -> Result<Account, RouterError> {
        let result = await router.request(.me(token: accessToken))
        return handleResult(result)
    }
    
    func karma() async -> Result<Karma, RouterError> {
        let result = await router.request(.karma(token: accessToken))
        return handleResult(result)
    }
    
    func prefs() async -> Result<AccountPreferences, RouterError> {
        let result = await router.request(.prefs(token: accessToken))
        return handleResult(result)
    }
    
    func trophies() async -> Result<TrophyList, RouterError> {
        let result = await router.request(.trophies(token: accessToken))
        return handleResult(result)
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
