//
//  CurrencyConverterResponseData.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 02.02.2025.
//

import Foundation

/// Currency сonverter response data
public struct CurrencyConverterResponseData: Decodable, Sendable {
    public let currency: String
    public let amount: String
}
