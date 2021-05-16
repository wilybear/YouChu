//
//  Keyword.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/15.
//

import Foundation

struct Keyword: Codable {
    let keyword: String

    enum CodingKeys: String, CodingKey {
        case keyword = "keyword_name"
    }
}
