//
//  Keyword.swift
//  YouChu
//
//  Created by κΉνμ on 2021/05/15.
//

import Foundation

struct Keyword: Codable {
    let keyword: String

    enum CodingKeys: String, CodingKey {
        case keyword = "keyword_name"
    }
}
