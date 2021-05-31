//
//  Banner.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/30.
//

import Foundation

struct Banner: Codable {
    let id: Int
    let bannerUrl: String
    let connectUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case bannerUrl = "banner_url"
        case connectUrl = "connect_url"
    }
}
