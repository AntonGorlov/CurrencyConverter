//
//  IRequestExecuter.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.02.2025.
//

import Foundation

/// Defines a contract for executing network requests.
protocol IRequestExecuter {
    
    /// Simple request with no response data.
    ///  Used for requests where you don't need to parse response data (like POST/PUT/DELETE operations) Uses a completion handler with Result type to handle success/failure
    /// - Parameters:
    ///   - request: URLRequest
    ///   - completion: Swift.Result<Void, RequestExecutionError>
    ///   Sendable is a protocol, that helps ensure thread safety in concurrent programming.
    func execute(_ request: URLRequest,
                 completion: @escaping @Sendable (Swift.Result<Void,
                                                  RequestExecutionError>) -> Void) async

    /// Request with decoded response. Automatically decodes the response into type T.Used for requests where you expect JSON data back (like GET operations)
    /// - Parameters:
    ///   - request: URLRequest
    ///   - decoder: JSONDecoder
    ///   - completion: Swift.Result<T, RequestExecutionError>
    func execute<T: Decodable>(_ request: URLRequest,
                               decoder: JSONDecoder,
                               completion: @escaping @Sendable (Swift.Result<T,
                                                                RequestExecutionError>) -> Void) async
}
