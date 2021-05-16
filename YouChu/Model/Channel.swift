//
//  Channel.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit

struct Channel: Codable {

    let channelId: String?
    let title: String?
    let description: String?
    let publishedAt: String?
    let thumbnail: String?
    let viewCount: Int?
    let subscriberCount: Int?
    let bannerImage: String?
    let videoCount: Int?
    var isPreffered: Bool

    var thumbnailUrl: URL? {
        URL(string: thumbnail!)
    }

    var bannerImageUrl: URL? {
        URL(string: bannerImage!)
    }

    var subscriberCountText: String? {
        guard let subscriberCount = subscriberCount else {
            return nil
        }
        return subscriberCount.roundedWithAbbreviations
    }

    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case title
        case description
        case publishedAt = "publishedAt"
        case thumbnail
        case viewCount = "view_count"
        case subscriberCount = "subscriber_count"
        case videoCount = "video_count"
        case bannerImage = "banner_image"
        case isPreffered = "preffered_flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        channelId = (try? values.decode(String.self, forKey: .channelId)) ?? nil
        title = (try? values.decode(String.self, forKey: .title)) ?? nil
        description = (try? values.decode(String.self, forKey: .description)) ?? nil
        publishedAt = (try? values.decode(String.self, forKey: .publishedAt)) ?? nil
        thumbnail = (try? values.decode(String.self, forKey: .thumbnail)) ?? nil
        viewCount = (try? values.decode(Int.self, forKey: .viewCount)) ?? nil
        subscriberCount = (try? values.decode(Int.self, forKey: .subscriberCount)) ?? nil
        bannerImage = (try? values.decode(String.self, forKey: .bannerImage)) ?? nil
        videoCount = (try? values.decode(Int.self, forKey: .videoCount)) ?? nil
        isPreffered = (try? values.decode(Bool.self, forKey: .isPreffered)) ?? false

    }
}
