//
//  RecipeView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI
import Kingfisher

struct RecipeView: View {
    let recipe: Recipe
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    KFImage(recipe.photoURL)
                        .resizable()
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(recipe.name)
                .font(.title)
                .bold()
            BadgeView(text: recipe.cuisine)
        }
    }
}

#Preview {
    RecipeView(
        recipe: .init(
            id: "",
            name: "Apam Balik",
            cuisine: "Malaysian",
            photoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
            source: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
            videoLink: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!
        )
    )
    .frame(width: 200)
    .padding()
}
