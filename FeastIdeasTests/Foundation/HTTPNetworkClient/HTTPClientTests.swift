//
//  HTTPClientTests.swift
//  FeastIdeasTests
//
//  Created by Luke Davis on 10/11/24.
//

import XCTest
@testable import FeastIdeas

final class HTTPClientTests: XCTestCase {

    let host = "https://test.com"
    var configuration: URLSessionConfiguration!
    var session: URLSession!
    var sut: HTTPClient!

    override func setUp() {
        super.setUp()
        configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        sut = HTTPClient(host: host, session)
    }

    // Test GET request with a valid response
    func testGetRequestSuccess() async throws {
        let mockResponseData = "{\"message\":\"Success\"}".data(using: .utf8)
        let expectedResponse = MockResponse(message: "Success")

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET", "Expected the request to be a GET")
            XCTAssertEqual(request.url?.path, "/test", "Expected the path to be '/test'")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockResponseData)
        }

        let response: MockResponse = try await sut.get(path: "/test")
        XCTAssertEqual(response.message, expectedResponse.message, "Expected a successful response")
    }

    // Test POST request with a valid response
    func testPostRequestSuccess() async throws {
        let mockResponseData = "{\"message\":\"Created\"}".data(using: .utf8)
        let expectedResponse = MockResponse(message: "Created")
        let requestBody = MockRequest(title: "New Post")

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST", "Expected the request to be a POST")
            let response = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            return (response, mockResponseData)
        }

        let response: MockResponse = try await sut.post(path: "/posts", body: requestBody)
        XCTAssertEqual(response.message, expectedResponse.message, "Expected a successful response")
    }

    // TODO: Add Put and Delete tests

    // Test handling a failed request (non-2xx status)
    func testFailedRequest() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }

        do {
            let _: MockResponse = try await sut.get(path: "/notfound")
            XCTFail("Expected to throw an error but didn't.")
        } catch let error as HTTPNetworkError {
            switch error {
            case .networkResponseFailure(let response):
                XCTAssertEqual(response.statusCode, 404, "Expected a 404 response")
            default:
                XCTFail("Unexpected error type")
            }
        }
    }

    // Test decoding error (invalid JSON)
    func testDecodingError() async throws {
        let invalidJsonData = "{\"invalid\":\"}".data(using: .utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJsonData)
        }

        do {
            let _: MockResponse = try await sut.get(path: "/test")
            XCTFail("Expected decoding error")
        } catch let error as HTTPNetworkError {
            switch error {
            case .parsingError(let data, _):
                XCTAssertEqual(data, invalidJsonData, "Expected the invalid json data to be returned")
            default:
                XCTFail("Unexpected error type")
            }
        }
    }
}

struct MockResponse: Decodable {
    let message: String
}

struct MockRequest: Encodable {
    let title: String
}
