//
//  CardView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

public struct CardView<Content: View>: View {
    var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading) {
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    CardView {
        VStack {
            Text("Test")
        }
    }
}
