//
//  GHAvatarImageView.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 19.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHAvatarImageView: UIImageView {

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = #imageLiteral(resourceName: "avatar-placeholder")
    }
}
