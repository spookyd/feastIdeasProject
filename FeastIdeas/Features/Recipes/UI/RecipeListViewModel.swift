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
        defer { isLoading = false }
        do {
            isLoading = true
            recipes = try await repository.fetchAllRecipes()
        } catch {
            // TODO: Display error message
        }
    }
}
