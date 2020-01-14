//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 13.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    
    let baseUrl: String = "https://api.github.com/users/"
    
    // MARK: - Privatr initializer
    
    private init() {}
    
    // MARK: - Functions
    
    func getFollowers(for username: String, page: Int, completionHandler: @escaping (Result<[Follower], GHError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUserName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completionHandler(.failure(.invalidRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponde))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completionHandler(.success(followers))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
