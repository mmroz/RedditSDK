//
//  RedditSDK.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation
import Combine

public class RedditSDK {
    
    // MARK: - Private Properties
    
    private let clientID: String
    private let redirectURI: String
    
    private var cancellables = Set<AnyCancellable>()
    
    private let authService: AuthenticationService
    private let redditService: RedditService
    
    // MARK: - Public Properties
    
    @Published public var isLoggedIn: Bool = false
    
    // MARK: - Lifecycle
    
    public init(clientID: String, redirectURI: String) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.authService = AuthenticationService(clientID: clientID, redirectURI: redirectURI)
        self.redditService = RedditService()
        
        registerSubscriptionHandlers()
    }
    
    // MARK: - Public
    
    // Authentication
    
    public func authenticate(duration: Duration, scope: Set<AuthScope>) {
        authService.authenticate(duration: duration, scope: scope)
    }
    
    public func signOut() {
        Task {
            await authService.signOut()
        }
    }
    
    // Reddit Api
    
    // Account
    
    public func me() async -> Result<Account, RouterError> {
        await redditService.me()
    }
    
    public func karma() async -> Result<Karma, RouterError> {
        await redditService.karma()
    }
    
    public func accountPreferences() async -> Result<AccountPreferences, RouterError> {
        await redditService.prefs()
    }
    
    func updateAccountPreferences(_ accountPreferences: AccountPreferences) {
        // TODO
    }
    
    public func trophies() async -> Result<TrophyList, RouterError> {
        await redditService.trophies()
    }
    
    // Collections
    
    func addPostToCollection() {
        // POST /api/v1/collections/add_post_to_collection
    }
    
    func collection() {
        // GET /api/v1/collections/collection
    }
    
    func createCollection() {
        // POST /api/v1/collections/create_collection
    }
    
    func deleteCollection() {
        // POST /api/v1/collections/delete_collection
    }
    
    func followCollection() {
        // POST /api/v1/collections/follow_collection
    }
    
    func removePostInCollection() {
        // POST /api/v1/collections/remove_post_in_collection
    }
    
    func reorderCollection() {
        // POST /api/v1/collections/reorder_collection
    }
    
    func subredditCollections() {
        // GET /api/v1/collections/subreddit_collections
    }
    
    func updateCollectionDescription() {
        // POST /api/v1/collections/update_collection_description
    }
    
    func updateCollectionDisplayLayout() {
        // POST /api/v1/collections/update_collection_display_layout
    }
    
    func updateCollectionTitle() {
        // POST /api/v1/collections/update_collection_title
    }
    
    // emoji
    
    func emoji() {
        // POST /api/v1/subreddit/emoji.json
    }
    
    func deleteEmoji() {
        // DELETE /api/v1/subreddit/emoji/emoji_name
    }
    
    func emojiAssetUpload() {
        // POST /api/v1/subreddit/emoji_asset_upload_s3.json
    }
    
    /**
     Set custom emoji size. Omitting width or height will disable custom emoji sizing.
     - Parameters:
       - height: an integer between 1 and 40 (default: 0)
       - width: an integer between 1 and 40 (default: 0)
     */
    func emojiCustomSize(height: Int = 0, width: Int = 0) {
        // POST /api/v1/subreddit/emoji_custom_size
    }
    
    /**
     Get all emojis for a SR. The response inclueds snoomojis as well as emojis for the SR specified in the request.

     The response has 2 keys: - snoomojis - SR emojis
     */
    func emojiAll() {
        // GET /api/v1/subreddit/emojis/all
    }
    
    // flair
    
    /**
     - Parameters:
       - apiType: the string json
       - flairType: the flair type
     */
    func clearFlairTemplates(apiType: String, flairType: FlairType) {
        // POST [/r/subreddit]/api/clearflairtemplates
    }
    
    /**
     - Parameters:
       - apiType: the string json
       - name: a user by name
     */
    func deleteFlair(apiType: String, name: String) {
        // POST [/r/subreddit]/api/deleteflair
    }
    
    /**
     - Parameters:
       - apiType: the string json
       - flairTemplateId: The flair template ID
     */
    func deleteFlairTemplate(apiType: String, flairTemplateId: String) {
        // POST [/r/subreddit]/api/deleteflair
    }
    
    /**
     - Parameters:
       - apiType: the string json
       - cssClass: a valid subreddit image name
       - link: a fullname of a link
       - name:  a user by name
       - text: a string no longer than 64 characters
     */
    func flair(apiType: String, cssClass: String, link: String, name: String, text: String) {
        // POST [/r/subreddit]/api/flair
    }
    
    /**
     Update the order of flair templates in the specified subreddit.
     Order should contain every single flair id for that flair type; omitting any id will result in a loss of data.
     - Parameters:
       - flairType: the flair type
       - subreddit: subreddit name
     */
    func flairTemplateOrder(flairType: FlairType, subreddit: String) {
        // PATCH [/r/subreddit]/api/flair_template_order
    }
    
    // TODO - add remaining flair methods
    
    // reddit gold
    
    // MARK: - Private
    
    private func registerSubscriptionHandlers() {
        authService.$state.sink { [weak self] state in
            self?.redditService.accessToken = state?.accessToken
            self?.isLoggedIn = state != nil
        }.store(in: &cancellables)
    }
}
