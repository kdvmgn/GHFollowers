//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 21.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

struct UIHelper {
    
    // MARK: - Static functions
    
    static func createThreeColumnsLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width: CGFloat = view.bounds.width
        let padding: CGFloat = 12.0
        let minimumItemSpacing: CGFloat = 10.0
        let availableWidth: CGFloat = width - (2 * padding) - (2 * minimumItemSpacing)
        let itemWidth: CGFloat = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding,
                                               left: padding,
                                               bottom: padding,
                                               right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
}
