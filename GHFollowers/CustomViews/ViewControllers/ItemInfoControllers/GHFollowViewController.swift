//
//  GHFollowViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 05.02.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHFollowViewController: GHItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    // MARK: - Private functions
    
    private func configureItem() {
        itemInfoLeft.configure(itemInfoType: .followers, withCount: user.followers)
        itemInfoRight.configure(itemInfoType: .following, withCount: user.following)
        actionButton.setup(title: "Get Followers", backgroundColor: .systemGreen)
    }
}
