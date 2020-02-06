//
//  DetailsViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 04.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

protocol DetailsViewControllerDelegate: class {
    func showFollowers(of userName: String)
}

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    let userName: String
    
    let headerView = UIView()
    
    let repoView = UIView()
    
    let followView = UIView()
    
    let dateLabel = GHBodyLabel(textAlignment: .center)
    
    var containerViews: [UIView] = []
    
    weak var delegate: DetailsViewControllerDelegate?
    
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
        containerViews = [headerView, repoView, followView, dateLabel]
        
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
            followView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: followView.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18.0)
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
            let repoViewController = GHRepoViewController(user: user)
            repoViewController.delegate = self
            let followViewController = GHFollowViewController(user: user)
            followViewController.delegate = self
            self.add(childViewController: GHDetailsViewController(user: user), to: self.headerView)
            self.add(childViewController: repoViewController, to: self.repoView)
            self.add(childViewController: followViewController, to: self.followView)
            self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
        }
    }
    
    // MARK: - Actions
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - GHRepoViewControllerDelegate

extension DetailsViewController: GHRepoViewControllerDelegate {
    
    // MARK: - Functions
    
    func showProfile(for user: User) {
        open(url: URL(string: user.htmlUrl))
    }
}

// MARK: - GHFollowViewControllerDelegate

extension DetailsViewController: GHFollowViewControllerDelegate {
    
    // MARK: - Functions
    
    func showFollowers(for user: User) {
        delegate?.showFollowers(of: user.login)
        dismissView()
    }
}
