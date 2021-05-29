//
//  TokenUtils.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/26.
//

import Security
import Alamofire

class TokenUtils {

    static let service = "https://www.youchu.link"
    static let account = "accessToken"

    func create(_ service: String, account: String, value: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
        ]

        SecItemDelete(keyChainQuery)

        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "failed to saving Tokens")
    }

    func read(_ service: String, account: String) -> String? {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)

        if status == errSecSuccess {
            let retruevedData = dataTypeRef as! Data
            let value = String(data: retruevedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }

    // Delete
    func delete(_ service: String, account: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]

        let status = SecItemDelete(keyChainQuery)
        print(status == noErr, "failed to delete the value, status code = \(status)")
    }

    // HTTPHeaders 구성
    func getAuthorizationHeader(serviceID: String) -> HTTPHeaders? {
        let serviceID = serviceID
        if let accessToken = self.read(serviceID, account: "accessToken") {
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"] as HTTPHeaders
        } else {
            return nil
        }
    }

    func getAccessToken(serviceID: String) -> String? {
        let serviceID = serviceID
        if let accessToken = self.read(serviceID, account: "accessToken") {
            return "Bearer \(accessToken)"
        } else {
            return nil
        }
    }

}
