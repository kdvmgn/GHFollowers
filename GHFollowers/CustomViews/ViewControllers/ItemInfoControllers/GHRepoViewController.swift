//
//  GHRepoViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 05.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHRepoViewController: GHItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    // MARK: - Private functions
    
    private func configureItem() {
        itemInfoLeft.configure(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoRight.configure(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.setup(title: "GitHub Profile", backgroundColor: .systemPurple)
    }
}
