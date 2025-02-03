//
//  Game.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//


struct Game: Codable, Equatable, Hashable {
    let title: String
    let imageName: String
    var isFavorite: Bool
}
