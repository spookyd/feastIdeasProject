//
//  BadgeView.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import SwiftUI

public struct BadgeView: View {
    var text: String
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var fontSize: CGFloat = 16
    var padding: CGFloat = 8

    public var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(textColor)
            .padding(.horizontal, padding)
            .padding(.vertical, padding / 2)
            .background(Capsule().fill(backgroundColor))
    }
}

#Preview {
    VStack(spacing: 20) {
        BadgeView(text: "SwiftUI", backgroundColor: .red)
        BadgeView(text: "iOS", backgroundColor: .green)
        BadgeView(text: "Badge", backgroundColor: .purple)
    }
    .padding()
}
