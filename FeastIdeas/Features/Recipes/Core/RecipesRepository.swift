//
//  RecipesRepository.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

public protocol RecipesRepository {
    func fetchAllRecipes() async throws -> [Recipe]
}
