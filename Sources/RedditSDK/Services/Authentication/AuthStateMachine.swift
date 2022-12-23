//
//  AuthStateMachine.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-22.
//

import Foundation

protocol AuthStateMachineDelegate: AnyObject {
    func didTransition(from: AuthStateMachine.State, to: AuthStateMachine.State)
}

class AuthStateMachine {
    
    // MARK: - Properties
        
    var state: State = .unauthorized {
        didSet {
            delegate?.didTransition(from: oldValue, to: state)
        }
    }
    
    private weak var delegate: AuthStateMachineDelegate?
    
    // MARK: - Lifecycle
    
    init(delegate: AuthStateMachineDelegate?) {
        self.delegate = delegate
    }
    
    func transition(to newState: State) {
        switch (state, newState) {
        case (_, .failed),
            (_, .unauthorized),
            (.unauthorized, .redirecting),
            (.unauthorized, .authorized),
            (.redirecting, .authorizing),
            (.authorizing, .authorized):
            state = newState
        default:
            fatalError("Illigal transition")
        }
    }
}

extension AuthStateMachine {
    enum State {
        case unauthorized
        case redirecting
        case authorizing(code: String)
        case authorized(AccessGrant)
        
        case failed
    }
}
