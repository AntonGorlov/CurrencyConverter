//
//  IConverterViewModelDelegate.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 06.02.2025.
//

import Foundation

/// Contract with an UI layer
protocol IConverterViewModelDelegate: AnyObject {
    func startLoading()
    func finishLoading()
    func receiveError(_ error: ConverterError)
    func convertedAmount(_ result: ConverterData)
}
