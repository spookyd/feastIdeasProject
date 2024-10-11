//
//  Recipe.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

public struct Recipe: Identifiable {
    public let id: String
    public let name: String
    public let cuisine: String
    public let photoURL: URL
    public let source: URL?
    public let videoLink: URL?

    public init(id: String, name: String, cuisine: String, photoURL: URL, source: URL?, videoLink: URL?) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.photoURL = photoURL
        self.source = source
        self.videoLink = videoLink
    }
}
