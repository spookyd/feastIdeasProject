//
//  ErrorDialogView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

struct ErrorDialogView: View {
    var message: String

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100)

            Text(message)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
}

#Preview {
    ErrorDialogView(message: "Failed to fetch data")
}
