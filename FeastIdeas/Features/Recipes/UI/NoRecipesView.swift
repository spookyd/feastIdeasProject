//
//  NoRecipesView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

struct NoRecipesView: View {
    var body: some View {
        VStack {
            Text("No Recipes")
                .font(.title)
                .foregroundStyle(Color.gray)
                .bold()
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    NoRecipesView()
}
