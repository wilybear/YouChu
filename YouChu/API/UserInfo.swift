//
//  UserAuth.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/19.
//

import UIKit
//import GoogleSignIN
import Alamofire

class UserInfo{

    static var user: User?
    static var topController: UINavigationController?

    static func fetchUser(userId: Int, completion: @escaping(Result<User?, Error>) -> Void){
        AF.request(baseUrl + "user", method: .get, parameters: ["user_id": userId])
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
}
