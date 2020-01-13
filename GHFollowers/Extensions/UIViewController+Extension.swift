//
//  UIViewController+Extension.swift
//  GHFollowers
//
//  Created by Кулешов Дмитрий Викторович on 13.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Functions
    
    func presentGHAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertViewController = GHAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen
            self.present(alertViewController, animated: true)
        }
    }
}
