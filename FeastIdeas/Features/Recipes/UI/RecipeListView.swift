//
//  RecipeListView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject private var viewModel: RecipeListViewModel
    var body: some View {
        List {
            ForEach(viewModel.recipes) { recipe in
                CardView {
                    RecipeView(recipe: recipe)
                }
            }
        }.task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    RecipeListView()
        .environmentObject(RecipeListViewModel(repository: PreviewStubs.recipesRepository))
}
