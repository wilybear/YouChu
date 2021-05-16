//
//  API.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/11.
//

import Foundation
import Alamofire

struct Service{
    static let baseUrl: String = "https://www.youchu.link/"

    static func fetchUserStat(userId: Int, completion: @escaping(User?) -> Void){
        AF.request(baseUrl + "user", method: .get, parameters: ["user_id": 1])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<User>.self) { response in
            switch response.result {
            case .success(_):
                completion(response.value?.data)
            case .failure(let err):
                print(err)
            }
        }
    }

    // TODO: should change channerlIndex to channelId
    static func fetchChannelDetail(channelIdx: Int, completion:@escaping(Channel?)->Void){
        AF.request(baseUrl + "channel", method: .get, parameters: ["channel_index": channelIdx])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Channel>.self) { response in
                switch response.result {
                case .success(_):
                    completion(response.value?.data)
                case .failure(let err):
                    print(err)
                }
            }
    }

    static func fetchKeywordList(channelIdx:Int, completion:@escaping([Keyword]?)->Void) {
        AF.request(baseUrl + "keyword", method: .get, parameters: ["channel_index": channelIdx])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[Keyword]>.self) { response in
                switch response.result {
                case .success(_):
                    completion(response.value?.data)
                case .failure(let err):
                    print(err)
                }
            }
    }
}
