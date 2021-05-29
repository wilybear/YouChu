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
    let standardValue: String?

    enum CodingKeys: CodingKey {
        case status, message, data, standardValue
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? nil
        message = (try? values.decode(String.self, forKey: .message)) ?? nil
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        standardValue = (try? values.decode(String.self, forKey: .standardValue)) ?? nil
    }
}

struct ResonseForResgister: Codable {
    let status: Int?
    let message: String?
    let exist: Bool?
    let token: String?
    let data: Int?
    enum Codingkeys: CodingKey {
        case status, message, exist, token, data
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? nil
        message = (try? values.decode(String.self, forKey: .message)) ?? nil
        exist = (try? values.decode(Bool.self, forKey: .exist)) ?? nil
        token = (try? values.decode(String.self, forKey: .token)) ?? nil
        data = (try? values.decode(Int.self, forKey: .data)) ?? nil
    }
}
