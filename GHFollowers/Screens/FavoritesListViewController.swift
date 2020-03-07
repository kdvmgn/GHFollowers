//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 10.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class FavoritesListViewController: GHDataLoadingViewController {
    
    // MARK: - Properties
    
    var favorites = [Follower]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteTableViewCell.self,
                           forCellReuseIdentifier: FavoriteTableViewCell.reusableID)
        tableView.removeExcessCells()
        return tableView
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retriveFavorites()
    }
    
    // MARK: - Private functions
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func retriveFavorites() {
        PersistenceManager.retriveFavorites { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let favorites):
                self.updateInterface(with: favorites)
            case .failure(let error):
                self.presentGHAlert(title: "Something wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func updateInterface(with favorites: [Follower]) {
        self.favorites = favorites
        DispatchQueue.main.async {
            if favorites.isEmpty {
                self.showEmptyStateView(with: "There are no favorites yet. Add them at the search tab", in: self.view)
            } else {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoritesListViewController: UITableViewDataSource {
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reusableID,
                                                 for: indexPath)
        if let cell = cell as? FavoriteCellProtocol {
            let favorite = favorites[indexPath.row]
            cell.configureFor(favotite: favorite)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesListViewController: UITableViewDelegate {
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followersViewController = FolloverListViewController(userName: favorite.login)
        navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let error = error else {
                return
            }
            self?.presentGHAlert(title: "Something wrong", message: error.rawValue, buttonTitle: "OK")
        }
    }
}
