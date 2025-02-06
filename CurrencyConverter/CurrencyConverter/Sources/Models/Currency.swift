//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 06.02.2025.
//

import Foundation

struct Currency: Equatable, Hashable {
    let code: String
    let name: String
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
