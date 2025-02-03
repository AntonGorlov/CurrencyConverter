//
//  ICurrencyConverterAPI.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 02.02.2025.
//

import Foundation

/// Defines a contract for performing currency conversion operations. It abstracts the logic for converting one currency to another, allowing different implementations (e.g., network-based, mock-based) to conform to the same interface.
public protocol ICurrencyConverterAPI {
    typealias GetCurrencyConverterResult = (Result<CurrencyConverterResponseData, BackendAPIError>) -> Void
    
    /// The method allows you to convert one type of currency to another
    /// - Parameters:
    ///   - requestData: CurrencyConverterRequestData
    ///   - completion: GetCurrencyConverterResult
    func сonvertСurrency(_ requestData: CurrencyConverterRequestData,
                           completion: @escaping GetCurrencyConverterResult)
}


