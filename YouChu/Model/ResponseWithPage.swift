//
//  ResponseWithPage.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/19.
//

import Foundation

struct Page<T: Codable>: Codable {
    let data: T?
    let last: Bool

    enum CodingKeys: String, CodingKey {
        case data = "content"
        case last
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        last = (try? values.decode(Bool.self, forKey: .last)) ?? true
    }
}
