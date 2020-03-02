//
//  User.swift
//  GHFollowers
//
//  Created by Дмитрий Кулешов on 13.01.2020.
//  Copyright © 2020 Dmitry Kuleshov. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
}
