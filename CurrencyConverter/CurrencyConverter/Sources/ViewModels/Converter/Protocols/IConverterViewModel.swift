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
    
    /// The number of valid digits that the user can enter
    var maxLengthUserInput: Int { get }
    
    init(apiService: ICurrencyConverterService, currencyProvider: ICurrencyProvider)
    
    /// Convert method
    /// - Parameters:
    ///   - amount: The amount to be converted
    ///   - from: The type of currency to be converted
    ///   - to: The type of currency to convert to
    func convertCurrencyAction(amount: String?,
                               from: String?,
                               to: String?) async
    
    /// Get all Currencies from CurrenciesProvider
    /// - Returns: [Currency]
    func getAllCurrencies() -> [Currency]
    
    /// Validate amount input data. Here some business rules
    /// - Parameter amount: User entered amount
    /// - Returns: Bool
    func isValidationAmountInput(_ amount: String?) -> Bool
    
    /// Validate Currencies
    /// - Returns: Bool
    /// - Parameters:
    ///   - fromCurrency: The type of currency to be converted
    ///   - toCurrency: The type of currency to convert to
    func isValidationCurrencies(_ fromCurrency: String?,
                                to toCurrency: String?) -> Bool
}
