//
//  Configuration.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.02.2025.
//

import Foundation

/// A type that holds the base URL and other configuration details for the API.
public struct Configuration: Sendable {
    public var baseURL: URL
    
    var commonHeaders: [String : String] = [
        "Content-Type" : "application/json"
    ]
}
