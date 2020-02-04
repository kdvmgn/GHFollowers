//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 14.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import Foundation

enum GHError: String, Error {
    case invalidUserName = "This username is invalid. Please check it and try again"
    case invalidRequest = "Unable to complete your request. Please try again later"
    case invalidResponde = "Invalid response from the server. Try again later"
    case invalidData = "The data recived from the server was invalid. Please try again"
}
