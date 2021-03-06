//
//  GHDetailsViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 04.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User!
    
    var avatarImageView = GHAvatarImageView(frame: .zero)
    
    var userNameLabel = GHTitleLabel(textAlignment: .left, fontSize: 34.0)
    
    var nameLabel = GHSecondaryLabel(fontSize: 18.0)
    
    var locationImageView = UIImageView()
    
    var locationLabel = GHSecondaryLabel(fontSize: 18.0)
    
    var bioLabel = GHBodyLabel(textAlignment: .left)
    
    // MARK: - Initializer
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        configureView()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        view.addSubviews(avatarImageView, userNameLabel, nameLabel, locationImageView, locationLabel, bioLabel)
    }
    
    private func setupLayout() {
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        let textImagePadding: CGFloat = 12.0
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 38.0),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20.0),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5.0),
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90.0)
        ])
    }
    
    private func configureView() {
        downloadAvatarImage()
        userNameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? "No bio availiable"
        bioLabel.numberOfLines = 3
        locationImageView.image = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
    }
    
    private func downloadAvatarImage() {
        NetworkManager.shared.downloadImage(from: user.avatarUrl) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }
}
