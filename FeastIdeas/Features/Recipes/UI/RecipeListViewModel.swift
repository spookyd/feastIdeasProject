//
//  RecipeListViewModel.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation
import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    private let repository: RecipesRepository

    @Published
    private(set) var isLoading: Bool = false
    @Published
    private(set) var recipes: [Recipe] = []

    init(repository: RecipesRepository) {
        self.repository = repository
    }

    func fetchRecipes() async {
        do {
            isLoading = true
            recipes = try await repository.fetchAllRecipes()
            isLoading = false
        } catch {
            print("Failed to fetch \(error)")
            // TODO: Display error message
            isLoading = false
        }
    }
}
