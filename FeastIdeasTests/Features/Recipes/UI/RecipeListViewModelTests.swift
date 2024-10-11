//
//  RecipeListViewModelTests.swift
//  FeastIdeasTests
//
//  Created by Luke Davis on 10/11/24.
//

import XCTest
@testable import FeastIdeas

final class RecipeListViewModelTests: XCTestCase {

    var repository: MockRecipesRepository!
    var sut: RecipeListViewModel!

    @MainActor override func setUp() {
        super.setUp()
        repository = MockRecipesRepository()
        sut = RecipeListViewModel(repository: repository)
    }

    @MainActor
    func testFetchRecipesSuccess() async {
        // Given
        let sampleRecipes = [
            Recipe(id: "1", name: "Pasta", cuisine: "Italian", photoURL: URL(string: "https://")!),
            Recipe(id: "2", name: "Sushi", cuisine: "Japanese", photoURL: URL(string: "https://")!)
        ]
        repository.onFetchRecipesResult = { .success(sampleRecipes) }

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertEqual(sut.recipes.count, sampleRecipes.count, "Expected the recipes count to be the same as the repo count")
        XCTAssertFalse(sut.isErrorDisplayed, "Expected no error to be displayed")
        XCTAssertNil(sut.errorMessage, "Expected no error message to be set")
        XCTAssertFalse(sut.isLoading, "Expected loading to be false after recipes fetched")
    }

    @MainActor
    func testFetchRecipesFailure() async {
        // Given
        repository.onFetchRecipesResult = { .failure(NSError(domain: "", code: 1, userInfo: nil)) }

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertEqual(sut.recipes.count, 0, "Expected no recipes to be available if fetch failed")
        XCTAssertTrue(sut.isErrorDisplayed, "Expected error message to be displayed")
        XCTAssertNotNil(sut.errorMessage, "Expected an error message to be set when fetch failure occurs")
        XCTAssertFalse(sut.isLoading, "Expected loading to be false after a failure occurs")
    }

    @MainActor
    func testFilterRecipesByCuisine() async {
        // Given
        let sampleRecipes = [
            Recipe(id: "1", name: "Pasta", cuisine: "Italian", photoURL: URL(string: "https://")!),
            Recipe(id: "2", name: "Sushi", cuisine: "Japanese", photoURL: URL(string: "https://")!),
            Recipe(id: "3", name: "Tacos", cuisine: "Mexican", photoURL: URL(string: "https://")!)
        ]
        repository.onFetchRecipesResult = { .success(sampleRecipes) }
        await sut.fetchRecipes()

        // When
        sut.filterRecipes(by: "Japanese")

        // Then
        XCTAssertEqual(sut.recipes.count, 1, "Expected only one recipe to be available after filtered")
        XCTAssertEqual(sut.recipes.first?.cuisine, "Japanese", "Expected only Japanese cuisines to be available")
    }

    @MainActor
    func testFilterRecipesByAll() async {
        // Given
        let sampleRecipes = [
            Recipe(id: "1", name: "Pasta", cuisine: "Italian", photoURL: URL(string: "https://")!),
            Recipe(id: "2", name: "Sushi", cuisine: "Japanese", photoURL: URL(string: "https://")!)
        ]
        repository.onFetchRecipesResult = { .success(sampleRecipes) }
        await sut.fetchRecipes()

        // When
        sut.filterRecipes(by: "All")

        // Then
        XCTAssertEqual(sut.recipes.count, sampleRecipes.count, "Expected the same number of recipes to be available when using the 'All' filter")
    }

}

class MockRecipesRepository: RecipesRepository {
    var onFetchRecipesResult: () -> Result<[Recipe], Error> = { .success([]) }

    func fetchAllRecipes() async throws -> [Recipe] {
        switch onFetchRecipesResult() {
        case .success(let recipes):
            return recipes
        case .failure(let error):
            throw error
        }
    }
}
