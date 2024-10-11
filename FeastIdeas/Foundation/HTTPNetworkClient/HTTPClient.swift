//
//  HTTPClient.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

public class HTTPClient {

    public typealias HeaderField = String
    public typealias HeaderValue = String

    private let session: URLSession
    private let host: String
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()

    public convenience init(host: String, headerFields: [HeaderField: HeaderValue] = [:]) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headerFields
        let session = URLSession(configuration: configuration)
        self.init(host: host, session)
    }

    init(host: String, _ session: URLSession) {
        self.session = session
        self.host = host
    }

    public func `get`<Response: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> Response {
        return try await sendRequest(path: path, method: "GET", body: Optional<Data>.none, queryItems: queryItems)
    }

    public func post<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        return try await sendRequest(path: path, method: "POST", body: body, queryItems: queryItems)
    }

    public func put<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        return try await sendRequest(path: path, method: "PUT", body: body, queryItems: queryItems)
    }

    public func delete<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        return try await sendRequest(path: path, method: "DELETE", body: body, queryItems: queryItems)
    }

    private func sendRequest<Body: Encodable, Response: Decodable>(
        path: String,
        method: String,
        body: Body?,
        queryItems: [URLQueryItem] = []
    )  async throws -> Response {
        guard var components = URLComponents(string: host) else {
            throw HTTPNetworkError.malformedURL("\(host)\(path)")
        }
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            throw HTTPNetworkError.malformedURL(components.string ?? path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        let response = try await session.data(for: request)
        if let httpResponse = response.1 as? HTTPURLResponse {
            let successStatusCodes = 200...299
            guard successStatusCodes.contains(httpResponse.statusCode) else {
                throw HTTPNetworkError.networkResponseFailure(httpResponse)
            }
        }
        do {
            return try decoder.decode(Response.self, from: response.0)
        } catch {
            throw HTTPNetworkError.parsingError(data: response.0, underlyingError: error)
        }
    }
}

extension HTTPClient {

    public func post<Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        return try await post(path: path, body: Optional<Data>.none, queryItems: queryItems)
    }

    public func put<Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        return try await put(path: path, body: Optional<Data>.none, queryItems: queryItems)
    }

    public func delete<Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        return try await delete(path: path, body: Optional<Data>.none, queryItems: queryItems)
    }
}
