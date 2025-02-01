//
//  RequestExecutionError.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.02.2025.
//

import Foundation

/// Errors that may occur when executing a request
public enum RequestExecutionError: Error {
    /// <#Description#>
    case networkUnavailable
    /// <#Description#>
    case timeout
    /// <#Description#>
    case connectionInterrupted
    /// <#Description#>
    case dataIsEmpty
    /// <#Description#>
    case httpStatusError(StatusError)
    /// DecodingError
    case serializationError(Error)
    /// <#Description#>
    case unexpected(Error?)
    
}

extension RequestExecutionError: Equatable {
    public static func == (lhs: RequestExecutionError, rhs: RequestExecutionError) -> Bool {
        switch (lhs, rhs) {
        case (.networkUnavailable, .networkUnavailable):
            return true
        case let (.httpStatusError(lhs), .httpStatusError(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
    
}
