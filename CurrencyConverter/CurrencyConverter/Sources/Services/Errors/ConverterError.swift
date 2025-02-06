//
//  ConverterError.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 05.02.2025.
//

import Foundation

enum ConverterError: LocalizedError {
    case invalidAmount(String)
    case invalidCurrency(String)
    case networkError(Error)
    case conversionFailed(String)
    case rateLimitExceeded
    case serverError(String)
    case noInternetConnection
    case dataIsEmpty
    case unexpected(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount(let message):
            return "Invalid amount: \(message)"
        case .invalidCurrency(let message):
            return "Invalid currency code: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .conversionFailed(let message):
            return "Conversion failed: \(message)"
        case .rateLimitExceeded:
            return "Too many requests. Please try again later."
        case .serverError(let message):
            return "Server error: \(message)"
        case .noInternetConnection:
            return "No internet connection. Check your connection."
        case .dataIsEmpty:
            return "Your request was not processed, Empty data was received." 
        case .unexpected(let message):
            return "Something went wrong: \(message)"
        }
    }
}
