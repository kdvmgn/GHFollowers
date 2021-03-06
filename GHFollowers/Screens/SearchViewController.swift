//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 10.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    let logoImage = UIImageView()
    
    let userNameTextField = GHTextField()
    
    let searchActionButton = GHButton(backgroundColor: .systemGreen, title: "Search Followers")

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImage, userNameTextField, searchActionButton)
        configureLogoImage()
        configureTextField()
        configureSearchActionButton()
        setupDismissalAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        userNameTextField.text = nil
    }
    
    // MARK: - Actions
    
    @objc func pushFollowersListViewController() {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            presentGHAlert(title: "Empty username", message: "Please enter a user name& We need to know who to look for", buttonTitle: "OK")
            return
        }
        userNameTextField.resignFirstResponder()
        let followersListViewController = FolloverListViewController(userName: userName)
        navigationController?.pushViewController(followersListViewController, animated: true)
    }
    
    // MARK: - Private functions
    
    private func configureLogoImage() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20.0 : 80.0
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalToConstant: 200),
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTextField() {
        userNameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 48)
        ])
    }
    
    private func configureSearchActionButton() {
        searchActionButton.addTarget(self, action: #selector(pushFollowersListViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchActionButton.heightAnchor.constraint(equalToConstant: 50),
            searchActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupDismissalAction() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    // MARK: - Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListViewController()
        return true
    }
}
