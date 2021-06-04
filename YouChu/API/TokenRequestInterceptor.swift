//
//  TokenRequestInterceptor.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/28.
//

import Alamofire
import GoogleSignIn

class TokenRequestInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay: TimeInterval = 1

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let tk = TokenUtils()
        if let token = tk.getAccessToken(serviceID: TokenUtils.service) {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        if let statusCode = response?.statusCode, statusCode == 302, request.retryCount < retryLimit {
            getNewAccessToken { result in
                result ? completion(.retry) : completion(.doNotRetry)
            }
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }

    func getNewAccessToken(completion: @escaping(_ isSuccess: Bool) -> Void) {
        var id: String?
        if let signIn = GIDSignIn.sharedInstance(), let currentUser = signIn.currentUser {
            id = currentUser.userID
        } else if let userId = UserDefaults.standard.string(forKey: "userId") {
            id = userId
        }
        guard let userId = id else {
            return
        }
        AF.request(baseUrl + "userIndex", method: .get, parameters: ["google_user_id": userId])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ResonseForResgister.self) { response in
            switch response.result {
            case .success(_):
                guard let token = response.value?.token else { return }
                let tk = TokenUtils()
                tk.create("https://www.youchu.link", account: "accessToken", value: token)
                completion(true)
            case .failure(let err):
                print(err)
                completion(false)
            }
        }
    }
}
