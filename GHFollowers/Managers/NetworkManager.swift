//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 13.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class NetworkManager {
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    private let baseUrl: String = "https://api.github.com/users/"
    
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
    
    func getUser(for username: String, completionHandler: @escaping (Result<User, GHError>) -> Void) {
        let endpoint = baseUrl + "\(username)"
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
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completionHandler(.success(user))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completionHandler(cachedImage)
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200, error == nil,
                let image = UIImage(data: data) else {
                return
            }
            self.imageCache.setObject(image, forKey: cacheKey)
            completionHandler(image)
        }
        
        task.resume()
    }
}
