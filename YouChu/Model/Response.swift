//
//  Response.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/15.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: Int?
    let message: String?
    let data: T?

    enum CodingKeys: CodingKey {
        case status,message, data
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? nil
        message = (try? values.decode(String.self, forKey: .message)) ?? nil
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
