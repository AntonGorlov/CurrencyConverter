//
//  ICurrencyProvider.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 06.02.2025.
//

import Foundation

/// Contract for available currency
protocol ICurrencyProvider {
    var availableCurrencies: [Currency] { get }
    func getAllCurrencies() -> [Currency]
    func isSupported(_ currency: String) -> Bool
}
