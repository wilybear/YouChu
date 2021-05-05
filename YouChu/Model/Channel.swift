//
//  Channel.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit

struct Channel {
    let thumbnail: UIImage
    let channelName: String
    let subscriberCount: Int
    var isprefered: Bool
    let instruction: String
//    let bannerImage: UIImage
    let keyword: [String]
}

class Test {
    static func fetchData() -> [Channel]{
        [
            Channel(thumbnail: #imageLiteral(resourceName: "yebit"), channelName: "Yebit 예빛", subscriberCount: 27, isprefered: true , instruction: "채널 소개가 없습니다", keyword: ["음악","감성 음악","인디","커버송"] ),
            Channel(thumbnail: #imageLiteral(resourceName: "sougu"), channelName: "승우아빠", subscriberCount: 141, isprefered: true, instruction: """
눈으로 보기만 할수 있는 채널이 아닌,
그냥 스쳐 지나가는 어려운 레시피가 아닌,
누구나 따라할 수 있는 레시피 채널을 만들고 싶어요!

*https://www.twitch.tv/swab85
""", keyword: ["승우아빠", "요리", "국진화", "레시피","철원"]),
            Channel(thumbnail: #imageLiteral(resourceName: "dingo"), channelName: "딩고 뮤직 / dingo music", subscriberCount: 293, isprefered: true, instruction: "소셜 모바일 세대를 위한 딩고 Dingo의 대표 음악채널 딩고 뮤직(Dingo Music). \n세로 라이브, 이슬 라이브 등 음악 라이브와 댄스, 예능 컨텐츠 등 단독 공개! \n\nCopyright 2015 MakeUs Co.,Ltd. All rights reserved", keyword: ["MV", "KPOP", "멜론" ,"melon","가수" ,"아이돌", "음악", "music dingo", "딩고" ,"딩고뮤직", "dingomusic"]),
            Channel(thumbnail: #imageLiteral(resourceName: "paka"), channelName: "PAKA", subscriberCount: 28, isprefered: true, instruction: "채널 소개가 없습니다",keyword: ["파카","리그오브레전드"]),

        ]
    }
}
