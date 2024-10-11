//
//  CloudFrontRecipesClientTests.swift
//  FeastIdeasTests
//
//  Created by Luke Davis on 10/11/24.
//

import XCTest
@testable import FeastIdeas

final class CloudFrontRecipesClientTests: XCTestCase {
    var httpClient: HTTPClient!
    var recipesClient: CloudFrontRecipesClient!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        httpClient = HTTPClient(host: "https://test.com", mockSession)
        recipesClient = CloudFrontRecipesClient(network: httpClient)
    }

    override func tearDown() {
        super.tearDown()
        httpClient = nil
        recipesClient = nil
    }

    // Test successful fetchAllRecipes
    func testFetchAllRecipesSuccess() async throws {
        // Given a valid response JSON
        let mockResponseData = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                }
            ]
        }
        """.data(using: .utf8)!

        // Mocking the HTTPClient response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockResponseData)
        }

        // When fetching recipes
        let recipes = try await recipesClient.fetchAllRecipes()

        // Then ensure the recipes are correctly parsed
        XCTAssertEqual(recipes.count, 1, "Expected only one recipe")
        let recipe = recipes.first
        XCTAssertEqual(recipe?.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8", "Expected uuid to map to the recipe id")
        XCTAssertEqual(recipe?.name, "Apam Balik", "Expected name to map to name")
        XCTAssertEqual(recipe?.cuisine, "Malaysian", "Expected cuisine to map to cuisine")
        XCTAssertEqual(
            recipe?.photoURL.absoluteString,
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "Expected to use large image for photo"
        )
        XCTAssertEqual(
            recipe?.source?.absoluteString,
            "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "Expected source_url to map to source"
        )
        XCTAssertEqual(
            recipe?.videoLink?.absoluteString,
            "https://www.youtube.com/watch?v=6R8ffRRJcrg",
            "Expected youtube_url to map to videoLink"
        )
    }

    // Test fetchAllRecipes with decoding error (invalid JSON)
    func testFetchAllRecipesDecodingError() async throws {
        // Given invalid JSON
        let invalidJsonData = """
        {
            "recipes": [
                {
                    "invalid_key": "value"
                }
            ]
        }
        """.data(using: .utf8)!

        // Mocking the HTTPClient response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJsonData)
        }

        // When fetching recipes
        do {
            let _ = try await recipesClient.fetchAllRecipes()
            XCTFail("Expected decoding error but no error was thrown")
        } catch let error as HTTPNetworkError {
            switch error {
            case .parsingError:
                // Success: decoding error was thrown
                return
            default:
                XCTFail("Unexpected error type")
            }
        }
    }

    // Test fetchAllRecipes with a network error (non-200 status code)
    func testFetchAllRecipesNetworkError() async throws {
        // Mocking a 500 Internal Server Error response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }

        // When fetching recipes
        do {
            let _ = try await recipesClient.fetchAllRecipes()
            XCTFail("Expected network error but no error was thrown")
        } catch let error as HTTPNetworkError {
            switch error {
            case .networkResponseFailure(let httpResponse):
                // Ensure we got the expected status code
                XCTAssertEqual(httpResponse.statusCode, 500, "Expected 500 status code")
            default:
                XCTFail("Unexpected error type")
            }
        }
    }
}
