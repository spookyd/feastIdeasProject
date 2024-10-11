//
//  RecipeListView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject private var viewModel: RecipeListViewModel
    @State private var isShowingActionSheet = false
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.recipes.isEmpty {
                    NoRecipesView()
                } else {
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
                }
                if viewModel.isErrorDisplayed {
                    ErrorDialogView(message: viewModel.errorMessage ?? "An unknown error occurred")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
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
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }, label: {
                        Image(systemName: "arrow.circlepath")
                    })
                }
                if !viewModel.filters.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isShowingActionSheet = true
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        })
                    }
                }
            }
            .confirmationDialog("Filter", isPresented: $isShowingActionSheet) {
                VStack {
                    ForEach(viewModel.filters, id: \.self) { filter in
                        Button(action: {
                            viewModel.filterRecipes(by: filter)
                        }, label: {
                            Text(filter)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeListView()
        .environmentObject(RecipeListViewModel(repository: PreviewStubs.recipesRepository))
}
