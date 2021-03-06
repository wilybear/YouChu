//
//  GoogleLoginViewController.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/03.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class GoogleLoginViewController: UIViewController {

    private lazy var googleSignInButton: GIDSignInButton = {
        let gidButton = GIDSignInButton()
        gidButton.style = .standard
        return gidButton
    }()

    private let icon: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "youchu_icon"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private lazy var appleSignInButton: UIStackView = {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        authorizationButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        let stackview = UIStackView()
        stackview.addArrangedSubview(authorizationButton)
        return stackview
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "유추".localized()
        label.font = UIFont.boldSystemFont(ofSize: 30.adjusted(by: .horizontal))
        return label
    }()
    private let support: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "구글 로그인만 유튜브 계정 연동을 지원합니다.".localized()
        label.font = UIFont.boldSystemFont(ofSize: 12.adjusted(by: .horizontal))
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainColor_3
        view.addSubview(googleSignInButton)
        view.addSubview(icon)
        view.addSubview(titleLabel)
        view.addSubview(support)
        icon.center(inView: view)
        icon.setDimensions(height: 250, width: 250)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: icon.bottomAnchor)
        support.centerX(inView: view)
        support.anchor(top: titleLabel.bottomAnchor, paddingTop: 5)

        let stackView = UIStackView(arrangedSubviews: [googleSignInButton, appleSignInButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.setHeight(100)
        view.addSubview(stackView)
        stackView.centerX(inView: view)
        stackView.anchor(top: support.bottomAnchor, paddingTop: 10)

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/youtube.readonly"]

    }

    func hasRequiredScope(scope: [Any]) -> Bool {
        return scope.contains { $0 as! String == "https://www.googleapis.com/auth/youtube.readonly"}
    }

    @objc func appleSignInButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}

extension GoogleLoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            let identityToken = appleIDCredential.identityToken
            let tokenString = String(data: identityToken!, encoding: .utf8)
//
//            print("User ID : \(userIdentifier)")
//            print("User Email : \(email ?? "")")
//            print("Token: \(String(describing: identityToken))")

            UserInfo.registerUser(identityToken: tokenString ?? "", appleId: userIdentifier, email: email ?? "") { result in
                switch result {
                case .success(let response):
                    let tk = TokenUtils()
                    guard let token = response.token else {
                        return
                    }
                    tk.create("https://www.youchu.link", account: "accessToken", value: token)
                    guard let user = response.data else {
                        return
                    }
                    UserInfo.fetchUser(userId: user) { result in
                        switch result {
                        case .success(let user):
                            let data: [String: User] = ["user": user!]
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "User"), object: nil, userInfo: data)
                            UserDefaults.standard.set(userIdentifier, forKey: "userId")
                         //   DataManager.sharedInstance.createUser()
                            self.dismiss(animated: false, completion: nil)
                        case .failure(let err):
                            self.showMessage(withTitle: "에러", message: "올바르지 않은 접근입니다. \(err)")
                        }
                    }
                case .failure(let err):
                    self.showMessage(withTitle: "로그안 실패", message: "계정 생성 및 로그인에 실패하셨습니다. \(err)")
                }
            }

        default:
            break
        }
    }

    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
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
      // If you ever changed the client ID you use for Google Sign-in, or
      // requested a different set of scopes, then also confirm that they
      // have the values you expect before proceeding.
        if signIn.currentUser.authentication.clientID != "235837674630-g4j6mibrsrtiomp5fus179jg796nmt0t.apps.googleusercontent.com"
            // TODO: Implement hasYourRequiredScopes
                || !self.hasRequiredScope(scope: signIn.currentUser.grantedScopes) {
          signIn.signOut()
        }

        signIn.currentUser.authentication.getTokensWithHandler { (auth, error) in
            guard error == nil else {
                signIn.signOut()
                return }
            let accessToken = auth?.accessToken
            UserInfo.registerUser(userToken: accessToken!, googleId: user.userID) { result in
                switch result {
                case .success(let response):
                    let tk = TokenUtils()
                    guard let token = response.token else {
                        return
                    }
                    tk.create("https://www.youchu.link", account: "accessToken", value: token)
                    guard let user = response.data else {
                        return
                    }
                    UserInfo.fetchUser(userId: user) { result in
                        switch result {
                        case .success(let user):
                            let data: [String: User] = ["user": user!]
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "User"), object: nil, userInfo: data)
                      //      DataManager.sharedInstance.createUser()
                            self.dismiss(animated: false, completion: nil)
                        case .failure(let err):
                            self.showMessage(withTitle: "에러", message: "올바르지 않은 접근입니다. \(err)")
                            signIn.signOut()
                        }
                    }
                case .failure(let err):
                    self.showMessage(withTitle: "로그안 실패", message: "계정 생성 및 로그인에 실패하셨습니다. \(err)")
                    signIn.signOut()
                }
            }
         }

    }

    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        DispatchQueue.main.async {
            let controller = GoogleLoginViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
