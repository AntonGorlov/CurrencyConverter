//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 05.02.2025.
//

import Foundation

@MainActor
class ConverterViewModel: IConverterViewModel {
    var apiService: ICurrencyConverterService
    
    required init(apiService: ICurrencyConverterService) {
        self.apiService = apiService
    }
    
   // MARK: - Actions
    
    func convertCurrencyAction(amount: Double,
                               from: String,
                               to: String) async {
        
        do {
            try await conversion(amount: amount, from: from, to: to)
        } catch let error {
            debugPrint(error)
        }
    }
    
    private func conversion(amount: Double, from: String, to: String) async throws {
        
        let result = try await apiService.convertCurrency(amount: amount,
                                                   from: from,
                                                   to: to)
        debugPrint("Result: \(result)")
        do {
            let response = try await apiService.convertCurrency(amount: amount, from: from, to: to)
            debugPrint("response: \(response)")
        } catch let error as ConverterError {
            debugPrint("ConverterError: \(error)")
        } catch {
            debugPrint("Unexpected error")
        }
    }
    
}
