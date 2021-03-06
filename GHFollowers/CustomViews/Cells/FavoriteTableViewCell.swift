//
//  FavoriteTableViewCell.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 01.03.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

protocol FavoriteCellProtocol {
    func configureFor(favotite: Follower)
}

class FavoriteTableViewCell: UITableViewCell {

    // MARK: - Static properties
    
    static let reusableID = "FavoriteTableViewCell"
    
    // MARK: - Properties
    
    let avatarImageView = GHAvatarImageView(frame: .zero)
    
    let usernameLabel = GHTitleLabel(textAlignment: .left, fontSize: 26.0)
    
    // MARK: - Initiaizer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        accessoryType = .disclosureIndicator
        
        let padding: CGFloat = 12.0
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40.0),
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
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

// MARK: - FavoriteCellProtocol

extension FavoriteTableViewCell: FavoriteCellProtocol {
    
    // MARK: - Functions
    
    func configureFor(favotite: Follower) {
        usernameLabel.text = favotite.login
        downloadAvatarImage(from: favotite.avatarUrl)
    }
}
