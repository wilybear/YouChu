//
//  Channel.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit

struct Channel: Codable {

//    public func encode(with coder: NSCoder) {
//        coder.encode(channelIdx, forKey: "channel_index")
//        coder.encode(channelId, forKey: "channel_id")
//        coder.encode(title, forKey: "title")
//        coder.encode(introduction, forKey: "introduction")
//        coder.encode(publishedAt, forKey: "published_at")
//        coder.encode(thumbnail, forKey: "thumbnail")
//        coder.encode(viewCount, forKey: "view_count")
//        coder.encode(bannerImage, forKey: "banner_image")
//        coder.encode(subscriberCount, forKey: "subscriber_count")
//        coder.encode(videoCount, forKey: "video_count")
//        coder.encode(isPreffered, forKey: "isPreferred")
//    }
//
//    public required init?(coder: NSCoder) {
//        self.channelIdx = coder.decodeObject(forKey: "channel_index") as? Int
//        self.channelId = coder.decodeObject(forKey: "channel_id") as? String
//        self.title = coder.decodeObject(forKey: "title") as? String
//        self.introduction = coder.decodeObject(forKey: "introduction") as? String
//        self.publishedAt = coder.decodeObject(forKey: "published_at") as? String
//        self.thumbnail = coder.decodeObject(forKey: "thumbnail") as? String
//        self.viewCount = coder.decodeObject(forKey: "view_count") as? Int
//        self.bannerImage = coder.decodeObject(forKey: "banner_image") as? String
//        self.subscriberCount = coder.decodeObject(forKey: "subscriber_count") as? Int
//        self.videoCount = coder.decodeObject(forKey: "video_count") as? Int
//        self.isPreffered = coder.decodeObject(forKey: "isPreferred") as? ChannelState ?? .normal
//    }

    var channelIdx: Int?
    var channelId: String?
    var title: String?
    var introduction: String?
    var publishedAt: String?
    var thumbnail: String?
    var viewCount: Int?
    var subscriberCount: Int?
    var bannerImage: String?
    var videoCount: Int?
    var isPreffered: ChannelState

    var thumbnailUrl: URL? {
        URL(string: thumbnail ?? "")
    }

    var bannerImageUrl: URL? {
        URL(string: bannerImage ?? "")
    }

    var subscriberCountText: String {
        guard let subscriberCount = subscriberCount else {
            return "-"
        }
        if subscriberCount == 0 {
            return "-"
        }
        return subscriberCount.roundedWithAbbreviations
    }

    enum CodingKeys: String, CodingKey {
        case channelIdx = "channel_index"
        case channelId = "channel_id"
        case title
        case introduction = "description"
        case publishedAt = "published_at"
        case thumbnail
        case viewCount = "view_count"
        case subscriberCount = "subscriber_count"
        case videoCount = "video_count"
        case bannerImage = "banner_image"
        case isPreffered = "isPreferred"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        channelIdx = (try? values.decode(Int.self, forKey: .channelIdx)) ?? nil
        channelId = (try? values.decode(String.self, forKey: .channelId)) ?? nil
        title = (try? values.decode(String.self, forKey: .title)) ?? nil
        introduction = (try? values.decode(String.self, forKey: .introduction)) ?? nil
        publishedAt = (try? values.decode(String.self, forKey: .publishedAt)) ?? nil
        thumbnail = (try? values.decode(String.self, forKey: .thumbnail)) ?? nil
        viewCount = (try? values.decode(Int.self, forKey: .viewCount)) ?? nil
        subscriberCount = (try? values.decode(Int.self, forKey: .subscriberCount)) ?? nil
        bannerImage = (try? values.decode(String.self, forKey: .bannerImage)) ?? nil
        videoCount = (try? values.decode(Int.self, forKey: .videoCount)) ?? nil
        isPreffered = (try? values.decode(ChannelState.self, forKey: .isPreffered)) ?? .normal
    }
}

enum ChannelState: Int, Codable {
    case normal = 0
    case prefer = 1
    case dislike = 2
}
