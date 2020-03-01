//
//  GHTabBarController.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 01.03.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class GHTabBarController: UITabBarController {

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(),
                           createFavoritesNavigationController()]
    }
    
    // MARK: - Private functions
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchViewController)
    }
    
    private func createFavoritesNavigationController() -> UINavigationController {
        let favoritesViewController = FavoritesListViewController()
        favoritesViewController.title = "Favorites"
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesViewController)
    }
}
