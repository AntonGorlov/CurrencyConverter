//
//  Configuration.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.02.2025.
//

import Foundation

public struct Configuration {
    public var baseURL: URL
    
    var commonHeaders: [String : String] = [
        
        "Content-Type" : "application/json"
    ]
}
