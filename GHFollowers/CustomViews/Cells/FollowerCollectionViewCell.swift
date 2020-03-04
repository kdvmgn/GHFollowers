//
//  FollowerCollectionViewCell.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 19.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

protocol FollowerCellProtocol {
    func configureFor(follower: Follower)
}

class FollowerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    static let reusableID = "FollowerCollectionViewCell"
    
    // MARK: - Properties
    
    let avatarImageView = GHAvatarImageView(frame: .zero)
    
    let usernameLabel = GHTitleLabel(textAlignment: .center, fontSize: 16.0)
    
    // MARK: - Initiaizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lify cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = Images.placeholder
    }
    // MARK: - Private functions
    
    private func configure() {
        addSubviews(avatarImageView, usernameLabel)
        let padding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12.0),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
    
    private func downloadAvatarImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }
}

// MARK: - FollowerCellProtocol

extension FollowerCollectionViewCell: FollowerCellProtocol {
    
    // MARK: - Functions
    
    func configureFor(follower: Follower) {
        usernameLabel.text = follower.login
        downloadAvatarImage(from: follower.avatarUrl)
    }
}
