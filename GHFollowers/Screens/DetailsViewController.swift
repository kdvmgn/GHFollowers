//
//  DetailsViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 04.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    let userName: String
    
    let headerView = UIView()
    
    let repoView = UIView()
    
    let followView = UIView()
    
    var containerViews: [UIView] = []
    
    // MARK: - Iniitializer
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        configureDoneButton()
        getUser()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        containerViews = [headerView, repoView, followView]
        
        containerViews.forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        })
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180.0),
            
            repoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            repoView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            followView.topAnchor.constraint(equalTo: repoView.bottomAnchor, constant: padding),
            followView.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    
    private func configureDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUser() {
        NetworkManager.shared.getUser(for: userName) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let user):
                print("User = \(user)")
                self.updateInfo(for: user)
            case .failure(let error):
                self.presentGHAlert(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    private func updateInfo(for user: User) {
        DispatchQueue.main.async {
            self.add(childViewController: GHDetailsViewController(user: user), to: self.headerView)
            self.add(childViewController: GHRepoViewController(user: user), to: self.repoView)
            self.add(childViewController: GHFollowViewController(user: user), to: self.followView)
        }
    }
    
    // MARK: - Actions
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}
