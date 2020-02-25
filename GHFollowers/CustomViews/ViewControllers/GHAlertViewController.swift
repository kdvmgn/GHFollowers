//
//  GHAlertViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 13.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var alertTitle: String?
    
    var messageTitle: String?
    
    var buttonTitle: String?
    
    var padding: CGFloat = 20.0
    
    let containerView = GHContainerView()
    
    lazy var titleLabel = GHTitleLabel(text: alertTitle, textAlignment: .center, fontSize: 20)
    
    lazy var messageLabel = GHBodyLabel(text: messageTitle, textAlignment: .center)
    
    lazy var actionButton = GHButton(backgroundColor: .systemPink, title: buttonTitle)
    
    // MARK: - Initializer
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.messageTitle = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViw()
        configureContainerView()
        configureTitleLabel()
        configureButton()
        configureMessageLabel()
        view.layoutIfNeeded()
    }
    
    // MARK: - Private functions
    
    private func configureViw() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280.0)
        ])
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureButton() {
        containerView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.heightAnchor.constraint(equalToConstant: 48.0),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16.0)
        ])
    }
    
    // MARK: - Actions
    
    @objc func dismissController() {
        dismiss(animated: true)
    }
}
