//
//  CurrencyProvider.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 06.02.2025.
//

import Foundation

class CurrencyProvider: ICurrencyProvider {
    private let currencies: [Currency] = [
        Currency(code: "USD", name: "US Dollar"),
        Currency(code: "EUR", name: "Euro"),
        Currency(code: "JPY", name: "Japan Yen"),
        Currency(code: "GBP", name: "British Pound")
    ]
    
    func getAllCurrencies() -> [Currency] {
        return currencies
    }
    
    var availableCurrencies: [Currency] {
        return currencies
    }
    
    func isSupported(_ currency: String) -> Bool {
        return currencies.contains { $0.code == currency.uppercased() }
    }
}
