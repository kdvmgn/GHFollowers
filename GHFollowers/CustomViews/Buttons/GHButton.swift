//
//  GHButton.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 10.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHButton: UIButton {

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String?) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    // MARK: - Functions
    
    func setup(title: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    // MARK: - Private functions
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }
}
