//
//  GHAvatarImageView.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 19.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHAvatarImageView: UIImageView {
    
    // MARK: - Properties
    
    let imageCache = NetworkManager.shared.imageCache

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func fetchImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            image = cachedImage
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
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private functions
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = #imageLiteral(resourceName: "avatar-placeholder")
    }
}
