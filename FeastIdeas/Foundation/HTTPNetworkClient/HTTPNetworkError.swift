//
//  HTTPNetworkError.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

public enum HTTPNetworkError: LocalizedError {
    case malformedURL(String)
    case networkResponseFailure(HTTPURLResponse)
    case parsingError(data: Data, underlyingError: Error)

    public var errorDescription: String? {
        switch self {
        case .malformedURL:
            return "Failed to create a URLRequest"
        case .networkResponseFailure:
            return "Server request failed"
        case .parsingError:
            return "Failed to parse the response from the server"
        }
    }

    public var failureReason: String? {
        switch self {
        case .malformedURL(let urlString):
            return "The provided url string (\(urlString)) is invalid."
        case .networkResponseFailure(let response):
            return "Server responded with a failure status code \(response.statusCode)"
        case .parsingError(_, let underlyingError):
            return underlyingError.localizedDescription
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .malformedURL(let urlString):
            return "Ensure the url string (\(urlString)) contains valid characters."
        case .networkResponseFailure:
            return nil
        case .parsingError(let data, _):
            return "Ensure the data format is expected. Data: \(String(data: data, encoding: .utf8) ?? "Missing Data")"
        }
    }
}
