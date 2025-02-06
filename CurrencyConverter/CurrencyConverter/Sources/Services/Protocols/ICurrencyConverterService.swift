//
//  ICurrencyConverterService.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 05.02.2025.
//

import Foundation
import BackendAPI

/// Defines a contract for executing currency converter service.
protocol ICurrencyConverterService {
    
    /// The method convects one currency into another
    /// - Parameters:
    ///   - amount: Amount of currency
    ///   - from: The currency to convert from
    ///   - to: The currency to convert to
    /// - Returns: ConverterData
    func convertCurrency(amount: Double,
                         from: String,
                         to: String) async throws -> ConverterData
    
    /// Validate input data. Here some business rules
    /// - Parameters:
    ///   - amount: Double
    ///   - from: String
    ///   - to: String
    func validationInput(amount: Double,
                         from: String,
                         to: String) throws
}
