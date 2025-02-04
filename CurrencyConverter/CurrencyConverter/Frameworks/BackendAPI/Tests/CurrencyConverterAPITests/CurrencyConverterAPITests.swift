//
//  CurrencyConverterAPITests.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 03.02.2025.
//

import XCTest
@testable import BackendAPI

// If you want to use a real request to the backend, and not a mock response (Which is not desirable, since tests should be fast, isolated and repeatable, but with a real request this will not work) Then do not use the MockRequestExecuter class in tests
final class CurrencyConverterAPITests: XCTestCase {
    var sut: CurrencyConverterAPIController!
    var mockRequestBuilder: MockCurrencyConverterAPIRequestsFactory!
    var mockRequestExecuter: MockRequestExecuter!
    
    override func setUp() {
        super.setUp()
        mockRequestBuilder = MockCurrencyConverterAPIRequestsFactory()
        mockRequestExecuter = MockRequestExecuter()
        sut = CurrencyConverterAPIController(mockRequestBuilder)
        sut.requestExecuter = mockRequestExecuter
    }
    
    override func tearDown() {
        sut = nil
        mockRequestBuilder = nil
        mockRequestExecuter = nil
        super.tearDown()
    }
    
    // MARK: - URL Tests
    
    func test_Request_URL_Format() async throws {
        // Given
        let requestData = CurrencyConverterRequestData(fromAmount: 120.25,
                                                       fromCurrency: "EUR",
                                                       toCurrency: "JPY")
        
        // When
        let urlRequest = try await mockRequestBuilder.buildGetConvertCurrencyRequest(requestData:
                                                                                        requestData)
        // Then
        XCTAssertNotNil(urlRequest.url)
        let urlString = urlRequest.url?.absoluteString ?? ""
        
        // Verify URL format
        XCTAssertTrue(urlString.contains("api.evp.lt/currency/commercial/exchange"))
        XCTAssertTrue(urlString.contains("\(requestData.fromAmount)-\(requestData.fromCurrency)"))
        XCTAssertTrue(urlString.contains(requestData.toCurrency))
        XCTAssertTrue(urlString.hasSuffix("/latest"))
        
        // Verify complete URL structure
        let expectedPath = "http://api.evp.lt/currency/commercial/exchange/\(requestData.fromAmount)-\(requestData.fromCurrency)/\(requestData.toCurrency)/latest"
        XCTAssertEqual(urlString, expectedPath)
    }
    
    // MARK: - Response Tests
    
    func test_Convert_Currency_Success_Response() async throws {
        // Given
        let requestData = CurrencyConverterRequestData(fromAmount: 120.25,
                                                       fromCurrency: "EUR",
                                                       toCurrency: "JPY")
        
        let mockResponse = try loadRecordedResponse()
        mockRequestExecuter.mockConvertCurrencyResult = .success(mockResponse)
        
        // When
        let result = await sut.сonvertСurrency(requestData)
        
        // Then
        switch result {
        case .success(let response):
           
            // Test response structure
            XCTAssertEqual(response.currency, requestData.toCurrency)
            
            // Test data validity
            XCTAssertNotNil(response.amount)
            XCTAssertFalse(response.amount.isEmpty)
            
            // Test that amount is a valid number string
            XCTAssertNotNil(Decimal(string: response.amount))
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func test_Convert_Currency_Request_Building_Error() async {
        // Given
        let requestData = CurrencyConverterRequestData(fromAmount: 100.0, fromCurrency: "USD", toCurrency: "EUR")
        let buildError = RequestBuildingError.unexpected(NSError(domain: "test", code: -1))
        mockRequestBuilder.mockBuildError = buildError
        
        // When
        let result = await sut.сonvertСurrency(requestData)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            switch error {
            case .requestBuildingError(let buildingError):
                XCTAssertNotNil(buildingError)
            default:
                XCTFail("Expected RequestBuildingError but got different error")
            }
        }
    }
    
    func test_Convert_Currency_With_Invalid_Recorded_Response() async {
        // Given
        let requestData = CurrencyConverterRequestData(fromAmount: 100.0, fromCurrency: "USD", toCurrency: "EUR")
        
        // Simulate corrupted or invalid recorded response
        mockRequestBuilder.mockBuildError = .serializationError(
            EncodingError.invalidValue("Invalid response",
                                       EncodingError.Context(codingPath: [], debugDescription: "Invalid response data"))
        )
        
        // When
        let result = await sut.сonvertСurrency(requestData)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            switch error {
            case .requestBuildingError:
                break
            default:
                XCTFail("Expected RequestBuildingError but got \(error)")
            }
        }
    }
    
    // MARK: - Backend API Error Tests
    
    func test_Backend_API_Error_Request_Building_Error() {
        let encodingError = EncodingError.invalidValue("test", .init(codingPath: [], debugDescription: "Test error"))
        let buildingError = RequestBuildingError.serializationError(encodingError)
        let backendError = BackendAPIError.requestBuildingError(buildingError)
        
        XCTAssertNotNil(backendError)
    }
    
    func test_Backend_API_Error_Request_Execution_Error() {
        let executionError = RequestExecutionError.networkUnavailable
        let backendError = BackendAPIError.requestExecutionError(executionError)
        
        XCTAssertNotNil(backendError)
    }
    
    // MARK: - Request Building Error Tests
    
    func test_Request_Building_Error_Serialization_Error() {
        let encodingError = EncodingError.invalidValue("test", .init(codingPath: [], debugDescription: "Test error"))
        let error = RequestBuildingError.serializationError(encodingError)
        
        XCTAssertNotNil(error)
    }
    
    // MARK: - Request Execution Error Tests
    
    func test_Request_Execution_Error_Equatable() {
        let error1 = RequestExecutionError.networkUnavailable
        let error2 = RequestExecutionError.networkUnavailable
        let error3 = RequestExecutionError.timeout
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func test_Request_Execution_Error_HTTP_Status_Error_Equatable() {
        let status1 = StatusError.badRequest
        let status2 = StatusError.badRequest
        let status3 = StatusError.unauthorized
        
        let error1 = RequestExecutionError.httpStatusError(status1)
        let error2 = RequestExecutionError.httpStatusError(status2)
        let error3 = RequestExecutionError.httpStatusError(status3)
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func test_Convert_Currency_Execution_Error() async {
        // Given
        let requestData = CurrencyConverterRequestData(fromAmount: 100.0, fromCurrency: "USD", toCurrency: "EUR")
        mockRequestExecuter.mockConvertCurrencyResult = .failure(.networkUnavailable)
        
        // When
        let result = await sut.сonvertСurrency(requestData)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            switch error {
            case .requestExecutionError(let executionError):
                XCTAssertEqual(executionError, .networkUnavailable)
            default:
                XCTFail("Expected RequestExecutionError but got different error")
            }
        }
    }
    
    // MARK: - Status Error Tests
    
    func test_Status_Error_Init_With_Raw_Value() {
        XCTAssertEqual(StatusError(400), .badRequest)
        XCTAssertEqual(StatusError(401), .unauthorized)
        XCTAssertEqual(StatusError(403), .forbidden)
        XCTAssertEqual(StatusError(404), .notFound)
        XCTAssertEqual(StatusError(999), .notDefined)
    }

    // MARK: - Helper Methods
    
    private func loadRecordedResponse() throws -> CurrencyConverterResponseData {
        guard let recordedResponseURL = getTestResourceURL() else
        {
            throw TestError.resourceNotFound
        }
        
        let recordedData = try Data(contentsOf: recordedResponseURL)
        return try JSONDecoder().decode(CurrencyConverterResponseData.self, from: recordedData)
    }
    
    func getTestResourceURL() -> URL? {
        let thisSourceFile = URL(fileURLWithPath: #filePath)
        let resourcesDirectory = thisSourceFile
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
        return resourcesDirectory.appendingPathComponent("test_currency_response.json")
    }
}

// MARK: - Mock Dependencies

class MockCurrencyConverterAPIRequestsFactory: ICurrencyConverterAPIRequestsFactory {
    var mockConvertCurrencyResult: Result<CurrencyConverterResponseData, RequestExecutionError>?
    var mockBuildError: RequestBuildingError?
    
    func buildGetConvertCurrencyRequest(requestData: CurrencyConverterRequestData) async throws -> URLRequest {
        if let error = mockBuildError {
            throw error
        }
        
        // Construct URL in the exact format required by the API
        let urlString = "http://api.evp.lt/currency/commercial/exchange/\(requestData.fromAmount)-\(requestData.fromCurrency)/\(requestData.toCurrency)/latest"
        guard let url = URL(string: urlString) else {
            throw RequestBuildingError.urlRequestInitializationError(
                NSError(domain: "Invalid URL", code: -1)
            )
        }
        
        return URLRequest(url: url)
    }
}

class MockRequestExecuter: IRequestExecuter {
    var mockSimpleRequestResult: Result<Void, RequestExecutionError> = .success(())
    var mockConvertCurrencyResult: Result<CurrencyConverterResponseData, RequestExecutionError>?
    
    func execute<T: Decodable>(_ request: URLRequest, decoder: JSONDecoder) async -> Result<T, RequestExecutionError> {
        if let result = mockConvertCurrencyResult as? Result<T, RequestExecutionError> {
            return result
        } else {
            fatalError("Unexpected type in mockConvertCurrencyResult")
        }
    }
    
    func execute(_ request: URLRequest) async -> Result<Void, BackendAPI.RequestExecutionError> {
        return mockSimpleRequestResult
    }
}

// MARK: - Errors

enum TestError: Error {
    case resourceNotFound
}
