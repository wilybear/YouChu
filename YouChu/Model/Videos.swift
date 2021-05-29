//
//  Videos.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit

struct Video: Codable {
    let thumbnail: String?
    let title: String?
    let viewCount: Int?
    let publishedAt: String?
    let videoId: String?

    var thumbnailUrl: URL? {
        URL(string: thumbnail ?? "")
    }

    var viewCountText: String {
        viewCount?.addComma() ?? "-"
    }

    enum CodingKeys: String, CodingKey {
        case thumbnail = "videoProfile"
        case title
        case publishedAt
        case viewCount
        case videoId = "videoId"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = (try? values.decode(String.self, forKey: .thumbnail)) ?? nil
        title = (try? values.decode(String.self, forKey: .title)) ?? nil
        viewCount = (try? values.decode(Int.self, forKey: .viewCount)) ?? nil
        publishedAt = (try? values.decode(String.self, forKey: .publishedAt)) ?? nil
        videoId = (try? values.decode(String.self, forKey: .videoId)) ?? nil
    }
}
//
// "videoProfile": "https://i.ytimg.com/vi/3hisEjbHylw/mqdefault.jpg",
//            "title": "[미리 보는 오픈마이크] 벌써부터 레전드 귀호강 예약👂! 매주 월/수 저녁 6시 유튜브 공개 | 비긴어게인 오픈마이크",
//            "publishedAt": "2021-05-21",
//            "viewCount": 10744
