//
//  StorageManager.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//


import Foundation

class StorageManager {
    static let shared = StorageManager() // Singleton instance

    private let userDefaults = UserDefaults.standard
    private let storageKey = "myGames" // Key for storing the data

    // Save items to storage
    func saveMyGames(_ items: [Game]) {
        do {
            let encodedData = try JSONEncoder().encode(items.sorted { $0.title < $1.title })
            userDefaults.set(encodedData, forKey: storageKey)
        } catch {
            print("Error encoding items: \(error)")
        }
    }

    // Load items from storage
    func loadItems() -> [Game] {
        guard let encodedData = userDefaults.data(forKey: storageKey) else {
            return []
        }
        let items = try? JSONDecoder().decode([Game].self, from: encodedData)
        return items?.sorted { $0.title < $1.title } ?? []
    }
    
    func resetStorage() {
        do {
            let encodedData = try JSONEncoder().encode(defaultGames)
            userDefaults.removeObject(forKey: storageKey)
            userDefaults.set(encodedData, forKey: storageKey)
        } catch {
            print("Error encoding items: \(error)")
        }
    }
    
    let defaultGames: [Game] = [
        Game(title: "The Legend of Zelda: Breath of the Wild", imageName: "zelda", isFavorite: false),
        Game(title: "Stardew Valley", imageName: "stardew", isFavorite: false),
        Game(title: "Celeste", imageName: "celeste", isFavorite: false),
        Game(title: "Hades", imageName: "hades", isFavorite: false),
        Game(title: "Hollow Knight", imageName: "hollowknight", isFavorite: false),
        Game(title: "Undertale", imageName: "undertale", isFavorite: false),
        Game(title: "Into the Breach", imageName: "intothebreach", isFavorite: false),
        Game(title: "Baba Is You", imageName: "babaisyou", isFavorite: false),
        Game(title: "Disco Elysium", imageName: "discoelysium", isFavorite: false),
        Game(title: "Outer Wilds", imageName: "outerwilds", isFavorite: false)
    ]
}
