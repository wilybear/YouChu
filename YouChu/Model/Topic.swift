//
//  Category.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/24.
//

import Foundation

struct TopicData: Codable {
    let topicName: String
    enum CodingKeys: String, CodingKey {
        case topicName = "topic_name"
    }
}

enum Topic: String, CaseIterable {
    case all = "전체"
    case videoGame = "비디오 게임 문화"
    case strategyVideoGame = "전략 게임"
    case casualGame = "캐주얼 게임"
    case actionAdventureGame = "액션 어드벤처 게임"
    case entertainment = "엔터테인먼트"
    case music = "음악"
    case musicOfAsia = "아시아 음악"
    case film = "필름"
    case actionGame = "액션 게임"
    case hobby = "취미"
    case lifestyle = "라이프스타일"
    case food = "음식"
    case rolePlayingVideoGame = "롤플레잉 게임"
    case performingArts = "예술"
    case popMusic = "팝"
    case pet = "펫"
    case televisionProgram = "TV 프로그램"
    case technology = "기술"
    case knowledge = "지식"
    case golf = "골프"
    case sport = "스포츠"
    case racingVideoGame = "레이싱 게임"
    case society = "사회"
    case electronicMusic = "일렉트로닉 음악"
    case health = "건강"
    case rockMusic = "록 뮤직"
    case vehicle = "차량"
    case puzzleVideoGame = "퍼즐 게임"
    case hipHopMusic = "힙합음악"
    case tourism = "관광업"
    case physicalFitness = "피트니스"
    case associationFootball = "축구"
    case politics = "정치"
    case independentMusic = "인디 뮤직"
    case fashion = "패션"
    case religion = "종교"
    case humour = "유머"
    case baseball = "야구"
    case physicalAttractiveness = "매력"
    case classicalMusic = "클래식 음악"
    case rAndB = "알앤비"
    case musicVideoGame = "음악 게임"
    case simulationVideoGame = "시뮬레이션 게임"
    case motorsport = "모터스포트"
    case sportsGame = "스포츠 게임"
    case jazz = "재즈"
    case soulMusic = "소울 뮤직"
    case mixedMartialArts = "종합 격투기"
    case christianMusic = "기독교 음악"
    case professionalWrestling = "프로 레슬링"
    case countryMusic = "컨트리 뮤직"
    case basketball = "농구"
    case business = "비즈니스"
    case musicOfLatinAmerica = "라틴 음악"
    case military = "군대"
    case boxing = "복싱"
    case volleyball = "배구"
    case americanFootball = "미식 축구"
    case tennis = "테니스"
    case reggae = "레게"
}
