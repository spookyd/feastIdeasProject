//
//  CloudFrontRecipeResponse.swift
//  FeastIdeas
//
//  Created by Luke Davis on 10/11/24.
//

import Foundation

struct CloudFrontRecipeResponse: Codable {
    let recipes: [CloudFrontRecipe]
}

struct CloudFrontRecipe: Codable {
    let uuid: String
    let cuisine: String
    let name: String
    let photoURLLarge: URL
    let photoURLSmall: URL
    // Assuming these two are optional since the "good" response does not have this for all entries.
    let sourceURL: URL?
    let youtubeURL: URL?

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
