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
    private var fetchedRecipes: [Recipe] = []
    @Published
    private(set) var recipes: [Recipe] = []
    private let allFilter: String = "All"
    @Published
    private(set) var filters: [String] = []

    init(repository: RecipesRepository) {
        self.repository = repository
    }

    func fetchRecipes() async {
        do {
            isLoading = true
            fetchedRecipes = try await repository.fetchAllRecipes()
            recipes = fetchedRecipes
            let filters = Set(recipes.map({ $0.cuisine }))
            if !filters.isEmpty {
                self.filters = [allFilter] + filters
            }
            isLoading = false
        } catch {
            print("Failed to fetch \(error)")
            // TODO: Display error message
            isLoading = false
        }
    }

    func filterRecipes(by cuisine: String) {
        if cuisine == allFilter {
            recipes = fetchedRecipes
        } else {
            recipes = fetchedRecipes.filter({ $0.cuisine == cuisine })
        }
    }
}
