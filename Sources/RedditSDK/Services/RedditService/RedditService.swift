//
//  RedditService.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

class RedditService {
    
    // MARK: - Properties
    
    private let networkManager: RedditNetworkManager
    
    // MARK: - Public Properties
    
    var accessToken: String? {
        get { networkManager.accessToken }
        set { networkManager.accessToken = newValue}
    }
    
    // MARK: - Lifecycle
    
    init() {
        self.networkManager = RedditNetworkManager()
    }
    
    // MARK: - Public
    
    func me() async -> Result<Account, RouterError> {
        await networkManager.me()
    }
    
    func karma() async -> Result<Karma, RouterError> {
        await networkManager.karma()
    }
    
    func prefs() async -> Result<AccountPreferences, RouterError> {
        await networkManager.prefs()
    }
    
    func trophies() async -> Result<TrophyList, RouterError> {
        await networkManager.trophies()
    }
}
