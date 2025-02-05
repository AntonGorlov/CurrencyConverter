//
//  IConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 05.02.2025.
//

import Foundation

/// Defines a contract for implement a converter viewModel
@MainActor
protocol IConverterViewModel {
    var apiService: ICurrencyConverterService { get }
    
    init(apiService: ICurrencyConverterService)
    
    /// Convert method
    /// - Parameters:
    ///   - amount: The amount to be converted
    ///   - from: The type of currency to be converted
    ///   - to: The type of currency to convert to
    func convertCurrencyAction(amount: Double,
                               from: String,
                               to: String) async
}
