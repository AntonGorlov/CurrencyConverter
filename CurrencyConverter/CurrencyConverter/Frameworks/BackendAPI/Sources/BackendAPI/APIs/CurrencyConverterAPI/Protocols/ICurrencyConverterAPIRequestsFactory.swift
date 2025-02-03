//
//  ICurrencyConverterAPIRequestsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 02.02.2025.
//

import Foundation

/// Defines a contract for creating URLRequest objects for currency conversion API requests. It abstracts the logic for constructing network requests, allowing different implementations (e.g., for different APIs or environments) to conform to the same interface.
public protocol ICurrencyConverterAPIRequestsFactory {
    
    /// Create a URLRequest for a currency conversion operation.
    /// - Parameter requestData: Containing the details of the conversion request (e.g., fromAmount, fromCurrency, toCurrency).
    /// - Returns: URLRequest
    func buildGetConvertCurrencyRequest(requestData:
                                        CurrencyConverterRequestData) throws -> URLRequest
}


