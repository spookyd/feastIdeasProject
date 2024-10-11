//
//  MockURLProtocol.swift
//  FeastIdeasTests
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    // Dictionary to map URLs to mock responses
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data?))?

    // Determines whether we can handle the request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // Return the request unchanged
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    // Start the request and provide a mock response
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Request handler is not set.")
        }

        // Call the handler to get the response
        let (response, data) = handler(request)

        // Send the mock response to the client
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }

        // Mark the request as finished
        client?.urlProtocolDidFinishLoading(self)
    }

    // Stop loading the request (no-op in this case)
    override func stopLoading() {}
}

