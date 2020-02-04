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
        configureDoneButton()
    }
    
    // MARK: - Functions
    
    private func configureDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}
