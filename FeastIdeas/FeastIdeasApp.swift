//
//  FeastIdeasApp.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

@main
struct FeastIdeasApp: App {
    @StateObject var viewModel = RecipeListViewModel(
        repository: CloudFrontRecipesClient(
            network: HTTPClient(host: "https://d3jbb8n5wk0qxi.cloudfront.net")
        )
    )
    var body: some Scene {
        WindowGroup {
            RecipeListView()
                .environmentObject(viewModel)
        }
    }
}
