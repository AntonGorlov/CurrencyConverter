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
    private let currencyProvider: ICurrencyProvider
    private var conversionTimer: Timer?
    private var lastCurrencyConversion: (amount: String, from: String, to: String)?
    let maxLengthUserInput = 8
    weak var delegate: IConverterViewModelDelegate?
    
    required init(apiService: ICurrencyConverterService,
                  currencyProvider: ICurrencyProvider) {
        self.apiService = apiService
        self.currencyProvider = currencyProvider
    }
    
    func getAllCurrencies() -> [Currency] {
        currencyProvider.getAllCurrencies()
    }
    
    // MARK: - Validations
    
    func isValidationAmountInput(_ amount: String?) -> Bool {
        guard let stringValue = amount else {
            return false
        }
        
        guard stringValue.count <= maxLengthUserInput else {
            return false
        }
        
        let components = stringValue.components(separatedBy: ".")
        guard components.count <= 2 else {
            return false
        }
        
        guard let value = Double(stringValue) else {
            return false
        }
        return value > 0
    }
    
    func isValidationCurrencies(_ fromCurrency: String?,
                                to toCurrency: String?) -> Bool {
        guard let _ = fromCurrency,
              let _ = toCurrency else {
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    func convertCurrencyAction(amount: String?,
                               from: String?,
                               to: String?) async {
        guard isValidationAmountInput(amount),
              let amountString = amount,
              let doubleValue = Double(amountString) else {
            delegate?.receiveError(.invalidAmount("Please fill correct amount value"))
            return
        }
        
        guard isValidationCurrencies(from, to: to),
              let fromCurrency = from,
              let toCurrency = to else {
            delegate?.receiveError(.invalidAmount("Invalid currencies"))
            return
        }
        
        lastCurrencyConversion = (amountString, fromCurrency, toCurrency)
        delegate?.startLoading()
        
        do {
            let result = try await conversion(amount: doubleValue, from: fromCurrency, to: toCurrency)
            delegate?.convertedAmount(result)
            automaticAPIRefresh()
        } catch let error as ConverterError {
            delegate?.receiveError(error)
        } catch {
            delegate?.receiveError(.unexpected(error.localizedDescription))
        }
        delegate?.finishLoading()
    }
    
    // MARK: - APIs
    
    private func conversion(amount: Double, from: String, to: String) async throws -> ConverterData {
        return try await apiService.convertCurrency(amount: amount,
                                                    from: from,
                                                    to: to)
    }
    
    private func automaticAPIRefresh() {
        conversionTimer?.invalidate()
        conversionTimer = nil
        guard let lastConvert = self.lastCurrencyConversion else {
            return
        }
        conversionTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            Task {
                
                await self.convertCurrencyAction(
                    amount: lastConvert.amount,
                    from: lastConvert.from,
                    to: lastConvert.to
                )
            }
        }
    }
    
    deinit {
        conversionTimer?.invalidate()
        conversionTimer = nil
    }
}
