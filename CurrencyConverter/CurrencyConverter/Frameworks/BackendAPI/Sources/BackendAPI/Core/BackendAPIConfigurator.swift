//
//  BackendAPIConfigurator.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.02.2025.
//

import Foundation

let MISS_CONFIG_FATAL_ERROR = "Missing required BackendAPIConfigurator.configuration. Set it by configure method"

/// Used to fetch the configuration. The configuration includes the base URL for the API.
public actor BackendAPIConfigurator: Sendable {
    public static let shared = BackendAPIConfigurator()
    
    public private(set) var configuration: Configuration?
    
    public func configure(baseURL url: URL) {
        
        self.configuration = Configuration(baseURL: url)
    }
    
    public func configure(_ configuration: Configuration) {
        
        self.configuration = configuration
    }
}
