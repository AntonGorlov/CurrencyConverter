//
//  CurrencyConverterAPIController.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 03.02.2025.
//

import Foundation

public class CurrencyConverterAPIController: AnyAPIContoller, ICurrencyConverterAPI {
    public var requestsBuilder: ICurrencyConverterAPIRequestsFactory
    
    public init(configuration: IConfiguration) {
        self.requestsBuilder = CurrencyConverterAPIRequestsFactory(configuration)
    }
    
    public func сonvertСurrency(_ requestData: CurrencyConverterRequestData) async -> GetCurrencyConverterResult {
        do {
            let request = try await requestsBuilder.buildGetConvertCurrencyRequest(requestData: requestData)
            typealias Response = Result<CurrencyConverterResponseData, RequestExecutionError>
            
            let result: Response = await self.requestExecuter.execute(request, decoder: self.decoder)
            
            switch result {
            case .success(let response):
                return .success(response)
            case .failure(let executionError):
                return .failure(.requestExecutionError(executionError))
            }
        } catch let error as RequestBuildingError {
            return .failure(.requestBuildingError(error))
        } catch {
            return .failure(.requestBuildingError(.unexpected(error)))
        }
    }
}
