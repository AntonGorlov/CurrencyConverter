//
//  CurrencyConverterService.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 05.02.2025.
//

import Foundation
import BackendAPI

class CurrencyConverterService: ICurrencyConverterService {
    private let apiController: ICurrencyConverterAPI
    private let currencyProvider: ICurrencyProvider
    
    init(apiController: ICurrencyConverterAPI,
         currencyProvider: ICurrencyProvider) {
        self.apiController = apiController
        self.currencyProvider = currencyProvider
    }
    
    func convertCurrency(amount: Double,
                         from: String,
                         to: String) async throws -> ConverterData {
        let requestData = CurrencyConverterRequestData(fromAmount: amount,
                                                       fromCurrency: from,
                                                       toCurrency: to)
        
        let result = await apiController.сonvertСurrency(requestData)
        
        switch result {
        case .success(let response):
            guard let _ = Decimal(string: response.amount) else {
                throw ConverterError.conversionFailed("Invalid response format")
            }
            return mapTo(response)
        case .failure(let error):
            throw try errorsAPIHandler(error)
        }
    }
    
    // MARK: Errors handler
    
    private func errorsAPIHandler(_ error: BackendAPIError) throws -> ConverterError {
        switch error {
        case .requestBuildingError(let requestBuildingError):
            throw ConverterError.conversionFailed("Failed to build request: \(requestBuildingError)")
        case .requestExecutionError(let executionError):
            switch executionError {
            case .networkUnavailable, .connectionInterrupted:
                throw ConverterError.noInternetConnection
            case .timeout:
                throw ConverterError.networkError(executionError)
            case .dataIsEmpty:
                throw ConverterError.dataIsEmpty
            case .httpStatusError(let statusError):
                switch statusError {
                case .badRequest:
                    throw ConverterError.invalidAmount("Invalid request format")
                case .unauthorized:
                    throw ConverterError.serverError("Authentication failed")
                case .forbidden:
                    throw ConverterError.rateLimitExceeded
                case .notFound:
                    throw ConverterError.serverError("Service not found")
                case .methodNotAllowed:
                    throw ConverterError.serverError("Invalid method")
                case .internalServerError:
                    throw ConverterError.serverError("Internal server error")
                default:
                    throw ConverterError.serverError("Unknown server error")
                }
            case .serializationError(let error):
                throw ConverterError.conversionFailed("Failed to parse response: \(error)")
            case .unexpected(let error):
                throw ConverterError.serverError("Unexpected error: \(error?.localizedDescription ?? "Unexpected")")
            }
        case .unexpected(let error):
            throw ConverterError.serverError("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func mapTo(_ response: CurrencyConverterResponseData) -> ConverterData {
        return ConverterData(amount: response.amount, currency: response.currency)
    }
}
