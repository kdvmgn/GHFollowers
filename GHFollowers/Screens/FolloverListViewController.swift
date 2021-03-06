//
//  FolloverListViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 10.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class FolloverListViewController: GHDataLoadingViewController {
    
    // MARK: - Nested type
    
    enum FollowersSection {
        case main
    }
    
    // MARK: - Properties
    
    var userName: String
    
    var followers: [Follower] = []
    
    var filteredFollowers: [Follower] = []
    
    var hasMoreFollowers: Bool = true
    
    var isLoadingInProcess: Bool = false
    
    var page: Int = 1
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<FollowersSection, Follower>!
    
    // MARK: - Private properties
    
    private var isSearching: Bool = false
    
    // MARK: - Initializer
    
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
        configureView()
        configureSearchController()
        configureCollectionView()
        fetchFollowers(userName: userName, page: page)
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Private functions

    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = userName
        configureAddButton()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnsLayout(in: view))
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reusableID)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
    }
    
    private func configureSearchController () {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FollowersSection, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reusableID, for: indexPath)
            if let cell = cell as? FollowerCellProtocol {
                cell.configureFor(follower: follower)
            }
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<FollowersSection, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func fetchFollowers(userName: String, page: Int) {
        showLoadingView()
        isLoadingInProcess = true
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] (result) in
            guard let self = self else {
                return
            }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                self.updateInterface(with: followers)
            case .failure(let error):
                self.presentGHAlert(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "OK")
            }
            self.isLoadingInProcess = false
        }
    }
    
    private func updateInterface(with followers: [Follower]) {
        self.hasMoreFollowers = followers.count == 100
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😀"
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers )
    }
    
    private func showInfo(for userName: String) {
        let userDetailsViewController = DetailsViewController(userName: userName)
        userDetailsViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: userDetailsViewController)
        present(navigationController, animated: true)
    }
    
    private func updatePersisted(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] (error) in
            if let error = error {
                self?.presentGHAlert(title: "Something went wrong",
                                     message: error.rawValue,
                                     buttonTitle: "OK")
                return
            }
            self?.presentGHAlert(title: "Success!",
                                 message: "You have successfully favorited this user",
                                 buttonTitle: "Hoooray 🥳")
        }
    }
    
     // MARK: - Actions
    
    @objc func addButtonTouched() {
        showLoadingView()
        NetworkManager.shared.getUser(for: userName) { [weak self] (result) in
            self?.dismissLoadingView()
            switch result {
            case .success(let user):
                self?.updatePersisted(user: user)
            case .failure(let error):
                self?.presentGHAlert(title: "Something went wrong!",
                                     message: error.rawValue,
                                     buttonTitle: "OK")
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension FolloverListViewController: UICollectionViewDelegate {
    
    // MARK: - Functions
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentHeight: CGFloat = scrollView.contentSize.height
        let contentOffsetY: CGFloat = scrollView.contentOffset.y
        let height: CGFloat = scrollView.bounds.size.height
        
        if (contentOffsetY > contentHeight - height) && hasMoreFollowers && !isLoadingInProcess {
            page += 1
            fetchFollowers(userName: userName, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataSource = isSearching ? filteredFollowers : followers
        let follower = dataSource[indexPath.row]
        showInfo(for: follower.login)
    }
}

// MARK: - UISearchResultsUpdating

extension FolloverListViewController: UISearchResultsUpdating {
    
    // MARK: - Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            updateData(on: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter({$0.login.lowercased().contains(filter.lowercased())})
        updateData(on: filteredFollowers)
    }
}

// MARK: - DetailsViewControllerDelegate

extension FolloverListViewController: DetailsViewControllerDelegate {
    
    // MARK: - Functions
    
    func showFollowers(of userName: String) {
        self.userName = userName
        title = userName
        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        fetchFollowers(userName: userName, page: page)
    }
}
