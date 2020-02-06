//
//  GHItemInfoViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 05.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHItemInfoViewController: UIViewController {

    // MARK: - Properties
    
    let stackView = UIStackView()
    
    let itemInfoLeft = GHItemInfoView()
    
    let itemInfoRight = GHItemInfoView()
    
    let actionButton = GHButton()
    
    var user: User!
    
    // MARK: - Initializer
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        setupView()
        configureStackView()
        configureActionButton()
    }
    
    // MARK: - Private functions
    
    private func configureBackground() {
        view.layer.cornerRadius = 18.0
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupView() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20.0
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50.0),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
        
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemInfoLeft)
        stackView.addArrangedSubview(itemInfoRight)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTouched), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func actionButtonTouched() {
        print("GHItemInfoViewController: action button touched")
    }
}
