//
//  AuthService.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation
import UIKit

class AuthenticationService: ObservableObject {
    
    // MARK: - Private Properties
    
    private let clientID: String
    private let redirectURI: String
    
    private let networkManager: AuthNetworkingManager
    private lazy var stateMachine = AuthStateMachine(delegate: self)
    private lazy var store = CredentialStore(clientID: clientID)
    
    private var checksum: String? = nil
    
    // MARK: - Public Properties
    
    @Published var state: AccessGrant? = nil
    
    // MARK: - Lifecycle
    
    init(clientID: String, redirectURI: String, notificationCenter: NotificationCenter = .default) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.networkManager = AuthNetworkingManager()
        
        notificationCenter.addObserver(forName: .authenticated, object: nil, queue: .main) { [weak self] notification in
            self?.handleAuthenticatedNotification(notification)
        }
        
        attemptRestoreToken()
    }
    
    // MARK: - Public
    
    func authenticate(duration: Duration, scope: Set<AuthScope>) {
        let state = UUID().uuidString
        checksum = state
        
        var urlComponents = URLComponents(string: "https://www.reddit.com")
        urlComponents?.path = "/api/v1/authorize"
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: ResponseType.code.rawValue),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "duration", value: duration.rawValue),
            URLQueryItem(name: "scope", value: scope.map(\.rawValue).joined(separator: ",")),
        ]
        
        guard let url = urlComponents?.url else {
            stateMachine.transition(to: .failed)
            return
        }
        
        UIApplication.shared.open(url) { [weak self] isSuccessful in
            guard isSuccessful else { return }
            self?.stateMachine.transition(to: .redirecting)
        }
    }
    
    func signOut() async {
        if let accessToken = state?.accessToken {
            await networkManager.revokeToken(clientID: clientID, token: accessToken, tokenType: .accessToken)
        }
        // TODO - remove the refresh token
        stateMachine.transition(to: .unauthorized)
    }
    
    // MARK: - Private
    
    private func handleAuthenticatedNotification(_ notification: Notification) {
        guard let code = notification.userInfo?["code"] as? String,
            let state = notification.userInfo?["state"] as? String,
            let checksum = checksum, checksum == state
        else {
            stateMachine.transition(to: .failed)
            return
        }
        
        stateMachine.transition(to: .authorizing(code: code))
    }
    
    private func attemptRestoreToken() {
        guard let grant = store.grant else {
            return
        }
        
        print("Token restored")
        stateMachine.transition(to: .authorized(grant))
    }
}

// MARK: - AuthStateMachineDelegate

extension AuthenticationService: AuthStateMachineDelegate {
    func didTransition(from: AuthStateMachine.State, to: AuthStateMachine.State) {
        print("Transition from \(from) to \(to)")
        
        switch (from, to) {
        case (.unauthorized, .redirecting):
            break
        case (.unauthorized, .authorized(let grant)):
            didAuthenticate(with: grant)
        case (.redirecting, .authorizing(let code)):
            fetchAccessToken(with: code)
        case (.authorizing, .authorized(let grant)):
            didAuthenticate(with: grant)
        case (_, .unauthorized):
            didAuthenticate(with: nil)
        default:
            break
        }
    }
    
    // Side effects
    
    private func fetchAccessToken(with code: String) {
        Task {
            switch await networkManager.accessToken(clientID: clientID, grantType: .authorizationCode, code: code, redirectURI: redirectURI) {
            case .failure:
                print("Could not fetch access token")
                stateMachine.transition(to: .failed)
            case .success(let accessToken):
                stateMachine.transition(to: .authorized(accessToken))
            }
        }
    }
    
    private func didAuthenticate(with accessGrant: AccessGrant?) {
        state = accessGrant
        store.grant = accessGrant
    }
}
