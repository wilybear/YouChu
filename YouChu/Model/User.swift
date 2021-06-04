//
//  User.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/15.
//

import UIKit

struct User: Codable {
    let id: Int
    let email: String
    let preferCount: Int
    let dislikeCount: Int
    let domain: Domain

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email = "user_email"
        case preferCount = "prefer_count"
        case dislikeCount = "dislike_count"
        case domain
    }
}

enum Domain: String, Codable {
    case google = "Google"
    case apple = "Apple"
}
