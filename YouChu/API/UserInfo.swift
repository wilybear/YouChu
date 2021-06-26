//
//  UserAuth.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/19.
//

import UIKit
// import GoogleSignIN
import Alamofire

class UserInfo {

    static var user: User?
    static var topController: UINavigationController?

    static func fetchUser(userId: Int, completion: @escaping(Result<User?, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "user", method: .get, parameters: ["user_id": userId], headers: header, interceptor: TokenRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<User>.self) { response in
            switch response.result {
            case .success(_):
                guard let value = response.value else { return }
                UserInfo.user = value.data
                do {
                    let encoder = JSONEncoder()
                    let encoded = try encoder.encode(value.data)
                    UserDefaults.standard.set(encoded, forKey: "user")
                } catch let error {
                    print(error)
                }
                completion(.success(value.data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    static func fetchUser(googleId: String, completion: @escaping(Result<User?, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "user", method: .get, parameters: ["google_user_id": googleId], headers: header, interceptor: TokenRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<User>.self) { response in
            switch response.result {
            case .success(_):
                guard let value = response.value else { return }
                UserInfo.user = value.data
                completion(.success(value.data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    static func registerUser(userToken: String, googleId: String, completion: @escaping(Result<ResonseForResgister, Error>) -> Void) {

        let header: HTTPHeaders = [ "Content-Type": "application/json" ]
        AF.request(baseUrl + "register", method: .post, parameters: ["user_token": userToken, "google_user_id": googleId], encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<400)
            .responseDecodable(of: ResonseForResgister.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value))
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
    }

    static func registerUser(identityToken: String, appleId: String, email: String, completion: @escaping(Result<ResonseForResgister, Error>) -> Void) {
        let header: HTTPHeaders = [ "Content-Type": "application/json" ]
        AF.request(baseUrl + "Apple/Register", method: .post, parameters: ["identity_token": identityToken, "apple_user_id": appleId, "user_email": email], encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<400)
            .responseDecodable(of: ResonseForResgister.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value))
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
    }

    static func deleteUserData(userId: Int, completion:@escaping(Result<Int, Error>) -> Void) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader(serviceID: TokenUtils.service) else {
            return
        }
        AF.request(baseUrl + "exit", method: .delete, parameters: ["user_id": userId], headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<Int>.self) { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {
                        return
                    }
                    completion(.success(value.data ?? 0))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

}
