//
//  API.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/11.
//

import Foundation
import Alamofire

struct Service {

    static func fetchChannelDetail(channelIdx: Int, completion:@escaping(Channel?) -> Void) {
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

    static func fetchKeywordList(channelIdx: Int, completion:@escaping([Keyword]?) -> Void) {
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

    static func fetchTopics(of channelIdx: Int, completion:@escaping([TopicData]?) -> Void) {
        print(channelIdx)
        AF.request(baseUrl + "getTopic", method: .get, parameters: ["channel_index": channelIdx])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[TopicData]>.self) { response in
                switch response.result {
                case .success(_):
                    completion(response.value?.data)
                case .failure(let err):
                    print(err)
                }
            }
    }

    static func fetchRandomChannel(userId: Int, completion: @escaping(Result<Channel, Error>) -> Void) {
        AF.request(baseUrl + "random", method: .get, parameters: ["user_id": userId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Channel>.self) { response in
                switch response.result {
                case .success(_):
                    guard let channel = response.value?.data else {
                        return
                    }
                    completion(.success(channel))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func fetchRecommendChannelList(userId: Int, size: Int, page: Int, completion:@escaping( Result<[Channel], Error>) -> Void) {
        AF.request(baseUrl + "recommend", method: .get, parameters: ["user_id": userId, "size": size, "page": page])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[Channel]>.self) { response in
                switch response.result {
                case .success(_):
                    guard let data = response.value?.data else {
                        return
                    }
                    completion(.success(data))
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
    }

    static func fetchRelatedChannels(userId: Int, size: Int, page: Int, completion:@escaping(Result<[Channel], Error>, String) -> Void) {
        AF.request(baseUrl + "relate", method: .get, parameters: ["user_id": userId, "size": size, "page": page])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[Channel]>.self) { response in
                switch response.result {
                case .success(_):
                    guard let data = response.value?.data else {
                        return
                    }
                    completion(.success(data), response.value?.standardValue ?? "")
                case .failure(let err):
                    completion(.failure(err), "")
                }
            }
    }

    static func fetchRankingChannelList(of topic: Topic, userId: Int, size: Int, page: Int, completion:@escaping(Result<Page<[Channel]>, Error>) -> Void) {
        AF.request(baseUrl + "rank", method: .get, parameters: ["topic_name": topic.rawValue, "size": size, "page": page, "user_id": userId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Page<[Channel]>>.self) { response in
                switch response.result {
                case .success(_):
                    guard let data = response.value?.data else {
                        return
                    }
                    completion(.success(data))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func fetchPreferChannelList(userId: Int, completion:@escaping(Result<[Channel], Error>) -> Void) {
        AF.request(baseUrl + "getPrefer", method: .get, parameters: ["user_id": userId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[Channel]>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data ?? []))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func fetchDislikeChannelList(userId: Int, completion:@escaping(Result<[Channel], Error>) -> Void) {
        AF.request(baseUrl + "getDislike", method: .get, parameters: ["user_id": userId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[Channel]>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data ?? []))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func deletePreferredChannel(userId: Int, channelIdx: Int, completion:@escaping(Result<Int, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "deletePreffered", method: .delete, parameters: ["user_id": userId, "channel_index": channelIdx], headers: header, interceptor: TokenRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Int>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data!))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func updatePreferredChannel(userId: Int, channelIdx: Int, completion:@escaping(Result<Int, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "prefer", method: .post, parameters: ["user_id": userId, "channel_index": channelIdx], encoding: JSONEncoding.default, headers: header, interceptor: TokenRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Int>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data!))
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
    }

    static func deleteDislikedChannel(userId: Int, channelIdx: Int, completion:@escaping(Result<Int, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "deleteDislike", method: .delete, parameters: ["user_id": userId, "channel_index": channelIdx], headers: header, interceptor: TokenRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Int>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data!))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func updateDislikedChannel(userId: Int, channelIdx: Int, completion:@escaping(Result<Int, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "dislike", method: .post, parameters: ["user_id": userId, "channel_index": channelIdx], encoding: JSONEncoding.default, headers: header, interceptor: TokenRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Int>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data!))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func fetchLatestVideos(of channelId: String, completion:@escaping(Result<[Video], Error>) -> Void) {
        AF.request(baseUrl + "latest", method: .get, parameters: ["channel_id": channelId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<[Video]>.self) { response in
                switch response.result {
                case .success(_):
                    guard let videos = response.value?.data else {
                        return
                    }
                    completion(.success(videos))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    static func fetchChannelListByKeyword(of keyword: String, userId: Int, size: Int, page: Int, completion:@escaping(Result<Page<[Channel]>, Error>) -> Void) {
        AF.request(baseUrl + "channelByKeyword", method: .get, parameters: ["keyword_name": keyword, "size": size, "page": page, "user_id": userId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Page<[Channel]>>.self) { response in
                switch response.result {
                case .success(_):
                    guard let data = response.value?.data else {
                        return
                    }
                    completion(.success(data))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
}
