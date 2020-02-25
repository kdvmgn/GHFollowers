//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 25.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import Foundation

enum PersistaceActionType {
    case add, remove
}

class PersistanceManager {
    
    // MARK: - Nested constants
    
    private struct Keys {
        static let favorites = "favorites"
    }
    
    // MARK: - Properties
    
    static private let defaults = UserDefaults.standard
    
    // MARK: - Static functions
    
    static func retriveFavorites(completionHandler: @escaping (Result<[Follower], GHError>) -> Void) {
        guard let favoritesData = defaults.data(forKey: Keys.favorites) else {
            completionHandler(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completionHandler(.success(favorites))
        } catch {
            completionHandler(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GHError? {
        do {
            let encoder = JSONEncoder()
            let favoritesData = try encoder.encode(favorites)
            defaults.setValue(favoritesData, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    static func updateWith(favorite: Follower,
                           actionType: PersistaceActionType,
                           completionHandler: @escaping (GHError?) -> Void) {
        retriveFavorites { (result) in
            switch result {
            case .success(let favorites):
                var retrivedFavorites: [Follower] = favorites
                switch actionType {
                case .add:
                    if !retrivedFavorites.contains(favorite) {
                        retrivedFavorites.append(favorite)
                    } else {
                        completionHandler(.alreadyFovorited)
                    }
                case .remove:
                    retrivedFavorites.removeAll(where: {$0.login == favorite.login})
                    completionHandler(save(favorites: retrivedFavorites))
                }
                completionHandler(save(favorites: retrivedFavorites))
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
}
