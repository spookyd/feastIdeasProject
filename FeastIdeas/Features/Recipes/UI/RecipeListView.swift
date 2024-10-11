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
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.recipes) { recipe in
                        CardView {
                            RecipeView(recipe: recipe)
                        }
                    }
                }
                .padding()
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .opacity(0.84)
                        ProgressView()
                            .tint(.white)
                    }
                    .frame(width: 100, height: 100)
                }
            }
            .task {
                await viewModel.fetchRecipes()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }, label: {
                        Image(systemName: "arrow.circlepath")
                    })
                }
            }
        }
    }
}

#Preview {
    RecipeListView()
        .environmentObject(RecipeListViewModel(repository: PreviewStubs.recipesRepository))
}
