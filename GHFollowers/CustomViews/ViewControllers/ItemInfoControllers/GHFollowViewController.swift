//
//  GHFollowViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 05.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

protocol GHFollowViewControllerDelegate: class {
    func showFollowers(for user: User)
}

class GHFollowViewController: GHItemInfoViewController {
    
    // NARK: - Properties
    
    weak var delegate: GHFollowViewControllerDelegate?
    
    // MARK: - Initializer
    
    init(user: User, delegate: GHFollowViewControllerDelegate?) {
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
        delegate?.showFollowers(for: user)
    }
    
    // MARK: - Private functions
    
    private func configureItem() {
        itemInfoLeft.configure(itemInfoType: .followers, withCount: user.followers)
        itemInfoRight.configure(itemInfoType: .following, withCount: user.following)
        actionButton.setup(title: "Get Followers", backgroundColor: .systemGreen)
    }
}
