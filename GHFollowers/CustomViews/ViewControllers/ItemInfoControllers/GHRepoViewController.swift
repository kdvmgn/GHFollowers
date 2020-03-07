//
//  GHRepoViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 05.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

protocol GHRepoViewControllerDelegate: class {
    func showProfile(for user: User)
}

class GHRepoViewController: GHItemInfoViewController {
    
    // MARK: - Properties
    
    weak var delegate: GHRepoViewControllerDelegate?
    
    // MARK: - Initializer
    
    init(user: User, delegate: GHRepoViewControllerDelegate?) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    // MARK: - Functions
    
    override func actionButtonTouched() {
        delegate?.showProfile(for: user)
    }
    
    // MARK: - Private functions
    
    private func configureItem() {
        itemInfoLeft.configure(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoRight.configure(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.setup(title: "GitHub Profile", backgroundColor: .systemPurple)
    }
}
