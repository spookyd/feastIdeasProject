//
//  CloudFrontRecipesClient.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

public struct CloudFrontRecipesClient: RecipesRepository {
    private let network: HTTPClient
    public init(network: HTTPClient) {
        self.network = network
    }

    public func fetchAllRecipes() async throws -> [Recipe] {
        let response: CloudFrontRecipeResponse = try await network.get(path: "/recipes.json")
        return response.recipes.map {
            .init(
                id: $0.uuid,
                name: $0.name,
                cuisine: $0.cuisine,
                photoURL: $0.photoURLLarge,
                source: $0.sourceURL,
                videoLink: $0.youtubeURL
            )
        }
    }
}
