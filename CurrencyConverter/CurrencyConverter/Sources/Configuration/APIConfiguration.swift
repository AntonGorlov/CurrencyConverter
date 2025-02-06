//
//  APIConfiguration.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 05.02.2025.
//

import Foundation
import BackendAPI

/// Configuration backendAPI
struct APIConfiguration: IConfiguration {
    var baseURL: URL {
        URL(fileURLWithPath: "http://api.evp.lt")
    }
    
    var commonHeaders: [String : String] = [
        "Content-Type" : "application/json"
    ]
}
