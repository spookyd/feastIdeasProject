//
//  StubbedRecipeRepository.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

private struct StubbedRecipeRepository: RecipesRepository {
    func fetchAllRecipes() async throws -> [Recipe] {
        return [
            .init(
                id: "1",
                name: "Food 1",
                cuisine: "Mexican",
                photoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
                source: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
                videoLink: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!),
            .init(
                id: "2",
                name: "Food 2",
                cuisine: "American",
                photoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg")!,
                source: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
                videoLink: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!)
        ]
    }
}

extension PreviewStubs {
    static let recipesRepository: RecipesRepository = StubbedRecipeRepository()
}
