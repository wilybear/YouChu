//
//  ResponseWithPage.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/19.
//

import Foundation


struct Page<T: Codable>: Codable {
    let data: T?

    enum CodingKeys: String,CodingKey {
        case data = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
