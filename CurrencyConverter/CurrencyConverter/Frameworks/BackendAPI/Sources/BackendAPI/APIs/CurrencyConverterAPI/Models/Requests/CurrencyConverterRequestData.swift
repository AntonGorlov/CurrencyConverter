//
//  CurrencyConverterRequestData.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 02.02.2025.
//

import Foundation

/// Currency сonverter request data
public struct CurrencyConverterRequestData {
    public let fromAmount: Double
    public let fromCurrency: String
    public let toCurrency: String
}
