//
//  GoogleLoginViewController.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/03.
//

import UIKit
import GoogleSignIn

class GoogleLoginViewController: UIViewController {

    private lazy var googleSignInButton: GIDSignInButton = {
        let gidButton = GIDSignInButton()
        gidButton.style = .standard
        return gidButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(googleSignInButton)
        googleSignInButton.center(inView: view)

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/youtube.readonly"]


    }
}

extension GoogleLoginViewController: GIDSignInDelegate {

    // 연동을 시도 했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        signIn.currentUser.authentication.getTokensWithHandler { (auth, error) in
            guard error == nil else { return }
            let accessToken = auth?.accessToken
            let refreshToken = auth?.refreshToken
            print("access: \(accessToken)")
            print("refresh: \(refreshToken)")
        }

        // 사용자 정보 가져오기
        if let userId = user.userID,                  // For client-side use only!
            let idToken = user.authentication.idToken, // Safe to send to the server
            let fullName = user.profile.name,
            let givenName = user.profile.givenName,
            let familyName = user.profile.familyName,
            let email = user.profile.email {

            print("Token : \(idToken)")
            print("User ID : \(userId)")
            print("User Email : \(email)")
            print("User Name : \((fullName))")

        } else {
            print("Error : User Data Not Found")
        }

        self.dismiss(animated: true, completion: nil)

    }

    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}


