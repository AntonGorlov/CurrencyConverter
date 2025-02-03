//
//  CurrencyConverterAPIRequestsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 03.02.2025.
//

import Foundation
import Alamofire

/// The CurrencyConverterAPIRequestsFactory class is responsible for creating URLRequest objects for currency conversion API requests. It conforms to the ICurrencyConverterAPIRequestsFactory protocol, ensuring a consistent interface for constructing network requests.
/// This class acts as a factory for URLRequest objects, encapsulating the logic for building requests based on input data (CurrencyConverterRequestData) and configuration (BackendAPIConfigurator).
class CurrencyConverterAPIRequestsFactory: ICurrencyConverterAPIRequestsFactory {
    var endpointsBuilder: ICurrencyConverterAPIEndpointsFactory
    
    init() async {
        endpointsBuilder = await CurrencyConverterAPIEndpointsFactory()
    }
    
    func buildGetConvertCurrencyRequest(requestData:
                                        CurrencyConverterRequestData) async throws -> URLRequest {
        do {
            guard let configuration = await BackendAPIConfigurator.shared.configuration else {
                
                fatalError(MISS_CONFIG_FATAL_ERROR)
            }
            let endpoint = endpointsBuilder.getConvertCurrencyRequestURL(fromAmount: requestData.fromAmount,
                                                                         fromCurrency: requestData.fromCurrency,
                                                                         toCurrency: requestData.toCurrency)
            let headers  = HTTPHeaders(configuration.commonHeaders)
            return try URLRequest(url: endpoint, method: .get, headers: headers )
        } catch let error as EncodingError {
            throw RequestBuildingError.serializationError(error)
        } catch let initializationError {
            throw RequestBuildingError.urlRequestInitializationError(initializationError)
        }
    }
    
}
