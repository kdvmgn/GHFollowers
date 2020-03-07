//
//  UITableView+Extension.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 04.03.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

extension UITableView {
    
    // MARK: - Functions
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
