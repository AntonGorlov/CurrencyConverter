//
//  AlamofireRequestExecutor.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.02.2025.
//

import Foundation
import Alamofire

/// This class is a robust and flexible solution for handling network requests in an iOS application using Alamofire.
/// Uses the Alamofire library to execute network requests. It handles both simple requests (where the response is not decoded) and requests where the response is expected to be a JSON object that can be decoded into a specified Decodable type. The class is designed to work in a concurrent environment, making it suitable for modern Swift concurrency.
actor AlamofireRequestExecuter: IRequestExecuter {
    let acceptableStatusCodes = 200..<300
    let acceptableContentTypes = ["application/json", "application/x-www-form-urlencoded"]
    
    init() {
        AF.sessionConfiguration.timeoutIntervalForRequest = 15
        AF.sessionConfiguration.timeoutIntervalForResource = 10
    }
    
    func execute(_ request: URLRequest,
                 completion: @escaping @Sendable (Result<Void, RequestExecutionError>) -> Void) async {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(.networkUnavailable))
            return
        }
        
        let statusCodes = acceptableStatusCodes
        let contentTypes = acceptableContentTypes
        
        let dataRequest = getDataRequest(form: request)
        
        dataRequest
            .validate(statusCode: statusCodes)
            .validate(contentType: contentTypes)
            .response { response in
                if let code = response.response?.statusCode,
                   statusCodes.contains(code) {
                    completion(.success(()))
                } else if let error = response.error {
                    let executionError = Self.mapError(error)  // Changed to Self.mapError
                    completion(.failure(executionError))
                } else {
                    completion(.failure(.unexpected(nil)))
                }
            }
    }
    
    func execute<T: Decodable & Sendable>(_ request: URLRequest,
                                         decoder: JSONDecoder,
                                         completion: @escaping @Sendable (Result<T, RequestExecutionError>) -> Void) async {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(.networkUnavailable))
            return
        }
        
        let statusCodes = acceptableStatusCodes
        let contentTypes = acceptableContentTypes
        
        let dataRequest = getDataRequest(form: request)
        
        dataRequest
            .validate(statusCode: statusCodes)
            .validate(contentType: contentTypes)
            .responseDecodable(of: T.self, decoder: decoder) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    let executionError = Self.mapError(error)  // Changed to Self.mapError
                    completion(.failure(executionError))
                }
            }
    }
    
    // Made static and nonisolated
    private static nonisolated func mapError(_ error: AFError) -> RequestExecutionError {
        switch error {
        case .sessionTaskFailed(let error as URLError) where error.code == .timedOut:
            return .timeout
        case .sessionTaskFailed(let error as URLError) where error.code == .networkConnectionLost:
            return .connectionInterrupted
        default:
            if let statusCode = error.responseCode {
                let statusError = StatusError(statusCode)
                return .httpStatusError(statusError)
            }
            else if error.isResponseSerializationError {
                return .serializationError(error)
            }
            else {
                return .unexpected(error)
            }
        }
    }
    
    private func getDataRequest(form urlRequest: URLRequest) -> DataRequest {
        return AF.request(urlRequest)
    }
}
