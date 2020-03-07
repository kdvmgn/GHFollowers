//
//  GHIitemInfoView.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 05.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class GHItemInfoView: UIView {

    // MARK: - Properties
    
    var symbolImageView = UIImageView()
    
    var titleLabel = GHTitleLabel(textAlignment: .left, fontSize: 14.0)
    
    var countLabel = GHTitleLabel(textAlignment: .center, fontSize: 14.0)
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func configure(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = SFSymbols.repos
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImageView.image = SFSymbols.gists
            titleLabel.text = "Public Gists"
        case .followers:
            symbolImageView.image = SFSymbols.followers
            titleLabel.text = "Followers"
        case .following:
            symbolImageView.image = SFSymbols.followings
            titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }
    
    // MARK: - Private functoions
    
    private func configureView() {
        addSubviews(symbolImageView, titleLabel, countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20.0),
            symbolImageView.heightAnchor.constraint(equalTo: symbolImageView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12.0),
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4.0),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18.0)
        ])
    }
}
