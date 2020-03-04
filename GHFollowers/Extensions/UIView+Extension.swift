//
//  UIView+Extension.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 04.03.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Finctions
    
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
}
