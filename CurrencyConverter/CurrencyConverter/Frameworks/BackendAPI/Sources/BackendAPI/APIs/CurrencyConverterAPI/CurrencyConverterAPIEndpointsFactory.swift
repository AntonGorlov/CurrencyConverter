//
//  CurrencyConverterAPIEndpointsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 02.02.2025.
//

import Foundation

/// The CurrencyConverterAPIEndpointsFactory class is responsible for creating URLs for currency conversion API requests. It adheres to the ICurrencyConverterAPIEndpointsFactory protocol, ensuring a consistent interface for generating API endpoints.
/// This class is designed to work with a backend configuration (provided by BackendAPIConfigurator) and dynamically constructs URLs based on input parameters such as fromAmount, fromCurrency, and toCurrency.
class CurrencyConverterAPIEndpointsFactory: ICurrencyConverterAPIEndpointsFactory {
    private(set) var configuration: Configuration
    
    init() async {
        guard let configuration = await BackendAPIConfigurator.shared.configuration else {
            fatalError(MISS_CONFIG_FATAL_ERROR)
        }
        
        self.configuration = configuration
    }
    
    // MARK: Endpoints
    
    //  Example: http://api.evp.lt/currency/commercial/exchange/340.51-EUR/JPY/latest
    func getConvertCurrencyRequestURL(fromAmount: Double,
                                      fromCurrency: String,
                                      toCurrency: String) -> URL {
        return configuration.baseURL
            .appending(path: "currency")
            .appending(path: "commercial")
            .appending(path: "exchange")
            .appending(path: "\(fromAmount)-\(fromCurrency)")
            .appending(path: "\(toCurrency)")
            .appending(path: "latest")
    }
}

