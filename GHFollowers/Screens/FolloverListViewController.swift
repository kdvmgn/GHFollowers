//
//  FolloverListViewController.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 10.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

class FolloverListViewController: UIViewController {
    
    // MARK: - Nested type
    
    enum FollowersSection {
        case main
    }
    
    // MARK: - Properties
    
    let userName: String
    
    var followers: [Follower] = []
    
    var hasMoreFollowers: Bool = true
    
    var page: Int = 1
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<FollowersSection, Follower>!
    
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
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnsLayout(in: view))
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reusableID)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
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
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<FollowersSection, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func fetchFollowers(userName: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] (result) in
            guard let self = self else {
                return
            }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                print("Followers.count = \(followers.count)")
                print(followers)
                self.hasMoreFollowers = followers.count == 100
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😀"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                self.updateData()
            case .failure(let error):
                self.presentGHAlert(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "OK")
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
        
        if (contentOffsetY > contentHeight - height) && hasMoreFollowers {
            page += 1
            fetchFollowers(userName: userName, page: page)
        }
    }
}
