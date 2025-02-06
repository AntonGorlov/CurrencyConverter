//
//  ICurrencyConverterAPIEndpointsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 02.02.2025.
//

import Foundation

/// A protocol that defines the interface for generating currency conversion API endpoints.
public protocol ICurrencyConverterAPIEndpointsFactory {
    
    /// Providing configuration
    var configuration: IConfiguration { get }
    
    init(configuration: IConfiguration)
    
    ///  Constructs a URL for a currency conversion request based on the provided parameters.
    /// - Parameters:
    ///   - fromAmount: The amount to convert (Double)
    ///   - fromCurrency: The currency code of the amount to convert (String)
    ///   - toCurrency: The target currency code for the conversion (String)
    /// - Returns: A URL object representing the API endpoint.
    func getConvertCurrencyRequestURL(fromAmount: Double,
                                      fromCurrency: String,
                                      toCurrency: String) -> URL
}
