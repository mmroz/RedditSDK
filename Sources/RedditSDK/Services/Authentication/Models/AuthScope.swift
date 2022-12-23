//
//  AuthScope.swift
//  RedditSdkDemo
//
//  Created by Mark Mroz on 2022-12-23.
//

import Foundation

public enum AuthScope: String, CaseIterable {
    case identity
    case edit
    case fliar
    case history
    case read
    case vote
    case wikiread
    case wikiedit
    case mysubreddits
}
