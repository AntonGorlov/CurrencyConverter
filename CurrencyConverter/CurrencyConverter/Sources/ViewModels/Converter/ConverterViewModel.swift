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
    private var lastCurrencyConversion: (amount: Double, from: String, to: String)?
    weak var delegate: IConverterViewModelDelegate?
    
    required init(apiService: ICurrencyConverterService,
                  currencyProvider: ICurrencyProvider) {
        self.apiService = apiService
        self.currencyProvider = currencyProvider
        automaticAPIRefresh()
    }
    
    func getAllCurrencies() -> [Currency] {
        currencyProvider.getAllCurrencies()
    }
    
    // MARK: - Actions
    
    func convertCurrencyAction(amount: Double,
                               from: String,
                               to: String) async {
        lastCurrencyConversion = (amount, from, to)
        delegate?.startLoading()
        
        do {
            let result = try await conversion(amount: amount, from: from, to: to)
            delegate?.updateConvertValues(result)
        } catch let error as ConverterError {
            delegate?.receiveError(error)
        } catch {
            delegate?.receiveError(.unexpected(error.localizedDescription))
        }
        delegate?.finishLoading()
    }
    
    private func conversion(amount: Double, from: String, to: String) async throws -> ConverterData {
        return try await apiService.convertCurrency(amount: amount,
                                                          from: from,
                                                          to: to)
    }
    
    private func automaticAPIRefresh() {
        conversionTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let lastConvert = self.lastCurrencyConversion else { return }
            
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
