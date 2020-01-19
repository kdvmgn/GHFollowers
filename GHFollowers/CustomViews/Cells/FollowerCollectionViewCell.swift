//
//  FollowerCollectionViewCell.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 19.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    static let reusableID = "FollowerCollectionViewCell"
    
    // MARK: - Properties
    
    let avatarImageView = GHAvatarImageView(frame: .zero)
    
    let usernameLabel = GHTitleLabel(textAlignment: .center, fontSize: 16.0)
    
    let padding: CGFloat = 8.0
    
    // MARK: - Initiaizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12.0),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
}
