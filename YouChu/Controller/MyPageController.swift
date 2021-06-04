//
//  MyPageController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit
import MessageUI
import Alamofire
import GoogleSignIn

let mypageCellIdentifier = "mypageCell"

class MyPageController: UIViewController {

    private let mypageTitle = ["버전 정보", "문의하기", "리뷰 작성하기", "구독 채널 동기화하기", "회원 탈퇴", "개인 정보 처리 방침", "오픈소스 라이센스", "서비스 이용 약관"]

    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 54.adjusted(by: .vertical)
        tv.delegate = self
        tv.dataSource = self
        tv.alwaysBounceVertical = false
        tv.separatorStyle = .none
        tv.register(MyPageTableViewCell.self, forCellReuseIdentifier: mypageCellIdentifier)
        return tv
    }()

    private let googleLogoView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    private let gmailAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16.adjusted(by: .horizontal))
        return label
    }()

    private let logoutButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("로그아웃".localized(), for: .normal)
        let color = UIColor.systemRed.withAlphaComponent(0.8)
        bt.setTitleColor(color, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14.adjusted(by: .horizontal))
        bt.titleLabel?.adjustsFontSizeToFitWidth = true
        bt.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return bt
    }()

    private lazy var accountStack: UIStackView = {

        let stack = UIStackView(arrangedSubviews: [googleLogoView, gmailAddressLabel, logoutButton])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 15.adjusted(by: .horizontal)
        stack.setDimensions(height: 60.adjusted(by: .vertical), width: view.frame.width - 60.adjusted(by: .horizontal))
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15.adjusted(by: .horizontal), bottom: 0, right: 10.adjusted(by: .horizontal))
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = .white
        stack.clipsToBounds = true
        stack.layer.cornerRadius = 10
        return stack
    }()

    private lazy var preferedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(preferTapAction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()

    private lazy var dislikedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(dislikeTapAction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()

    private lazy var channelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [preferedLabel, dislikedLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20.adjusted(by: .horizontal)
        stack.setDimensions(height: 75.adjusted(by: .vertical), width: view.frame.width - 60.adjusted(by: .horizontal))
        preferedLabel.setHeight(75)
        dislikedLabel.setHeight(75)

        return stack
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserStats()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - API
    func fetchUserStats() {
        guard let user = UserInfo.user else {
            return
        }
        UserInfo.fetchUser(userId: user.id) { response in
            switch response {
            case .success(let user):
                guard let user = user else {
                    return
                }
                self.gmailAddressLabel.text = user.email
                self.preferedLabel.attributedText = self.attributedStatText(value: user.preferCount, label: "선호 채널".localized())
                self.dislikedLabel.attributedText = self.attributedStatText(value: user.dislikeCount, label: "비선호 채널".localized())
                self.googleLogoView.image = user.domain == .google ? #imageLiteral(resourceName: "google") : UIImage(systemName: "applelogo")?.withTintColor(.black)
                if user.domain == .apple {
                    self.logoutButton.removeFromSuperview()
                    self.googleLogoView.setDimensions(height: 20, width: 15)
                    self.googleLogoView.tintColor = .black
                }
            case .failure(_):
                break
            }
        }
    }

    // MARK: - Helpers
    private func configureUI() {
        let bgColor = UIColor.systemGray6.withAlphaComponent(0.6)
        view.backgroundColor = bgColor
        navigationItem.title = "내 정보".localized()
        view.addSubview(accountStack)

        googleLogoView.setDimensions(height: 20, width: 20, by: .horizontal)
        accountStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)

        view.addSubview(channelStack)
        channelStack.centerX(inView: view)
        channelStack.anchor(top: accountStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)

        view.addSubview(tableView)
        tableView.centerX(inView: view)
        tableView.anchor(top: channelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30 )
        tableView.setHeight(CGFloat(54 * mypageTitle.count))

    }
    private func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.adjusted(by: .vertical)
        paragraphStyle.alignment = .center
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 17.adjusted(by: .horizontal))])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 17.adjusted(by: .horizontal)), .foregroundColor: UIColor.lightGray]))
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        return attributedText
    }
    private func openAppStoreReview() {
        if let appstoreURL = URL(string: "https://apps.apple.com/app/id1569978828") {
            // TODO: should change app id
            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [
              URLQueryItem(name: "action", value: "write-review")
            ]
            guard (components?.url) != nil else {
                return
            }
            UIApplication.shared.open(appstoreURL, options: [:], completionHandler: nil)
        }
    }

    // MARK: - Actions
    @objc func preferTapAction(sender: UITapGestureRecognizer) {
        let controller = ChannelListController(title: "선호채널".localized(), type: .prefer)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func dislikeTapAction(sender: UITapGestureRecognizer) {
        let controller = ChannelListController(title: "비선호채널".localized(), type: .dislike)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func logout() {
        guard let user = UserInfo.user else {
            return
        }
        if user.domain == .apple {
            self.showMessage(withTitle: "죄송합니다.", message: "애플 유저는 회원탈퇴를 이용해주세요")
        } else {
            guard let signIn = GIDSignIn.sharedInstance() else { return }
            let tk = TokenUtils()
            tk.delete(TokenUtils.service, account: TokenUtils.account)
            signIn.signOut()
            DataManager.sharedInstance.deleteUser()
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                // Comment if you want to minimise app
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (_) in
                    exit(0)
            }
        }
    }

    @objc func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        // TODO: change email
        composer.setToRecipients(["youchu0530@gmail.com"])
        composer.setSubject("[유추 의견 제출]")
        composer.setMessageBody("", isHTML: false)
        present(composer, animated: true)
    }

    func deleteUser() {
        guard let user = UserInfo.user else {
            return
        }
        showLoader(true)
        UserInfo.deleteUserData(userId: user.id) { result in
            switch result {
            case .success(_):
                DataManager.sharedInstance.deleteUser()
                var message = "성공적으로 회원탈퇴가 이루어졌습니다. 감사합니다."
                if user.domain == .apple {
                    message += "애플 유저는 설정 > 암호 및 보안 > Apple ID를 사용하는 앱 에서 해당 앱을 삭제해야 정상적으로 탈퇴됩니다."
                }
                let alert = UIAlertController(title: "회원 탈퇴", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
                    exit(0)
                }))
                let tk = TokenUtils()
                tk.delete(TokenUtils.service, account: TokenUtils.account)
                GIDSignIn.sharedInstance()?.signOut()
                self.showLoader(false)
                self.present(alert, animated: true)
            case .failure(let err):
                self.showLoader(false)
                self.showMessage(withTitle: "회원탈퇴", message: "회원탈퇴에 실패하였습니다. 지속적으로 문제 발생시 메일로 연락주세요. \(err)")

            }
        }
    }

    func syncYTSubscribtionList() {
        guard let signIn = GIDSignIn.sharedInstance() else {return}
        signIn.currentUser.authentication.getTokensWithHandler { (auth, error) in
            if error != nil {
                self.showMessage(withTitle: "Error", message: "\(String(describing: error))")
            }
            if let accessToken = auth?.accessToken, let userId = signIn.currentUser.userID {
                self.showLoader(true)
                UserInfo.registerUser(userToken: accessToken, googleId: userId) { result in
                    self.showLoader(false)
                    switch result {
                    case .success(_):
                        self.fetchUserStats()
                        self.showMessage(withTitle: "동기화 성공", message: "성공적으로 유튜브 구독 목록을 불러왔습니다.")
                    case .failure(_):
                        self.showMessage(withTitle: "동기화 실패", message: "유튜브 구독 목록을 불러오는데 실패했습니다. 구글 계정의 유투브 엑세스 권환을 확인해주세요.")
                    }
                }
            } else {
                self.showMessage(withTitle: "Error", message: "access Token을 가져오는데 실패했습니다.")
            }

        }
    }

}

// MARK: - TableViewDelegate, DataSource

extension MyPageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mypageTitle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: mypageCellIdentifier, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        cell.title = mypageTitle[indexPath.row].localized()
        if indexPath.row == 0 { cell.addVersionInfo() }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            // mail
            showMailComposer()
        case 2:
            // review
            openAppStoreReview()
        case 3:
            // 동기화
            syncYTSubscribtionList()
        case 4: // 회원탈퇴
            let alert = UIAlertController(title: "회원 탈퇴", message: "정말로 탈퇴하시겠습니까? 탈퇴 시 모든 데이터가 서버에서 삭제됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
                self.deleteUser()
            }))
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        case 5: // 개인정보 처리 방침
            if let url = URL(string: "https://www.youchu.link/Personal_Information.html") {
                UIApplication.shared.open(url)
            }

        case 6: // 오픈 소스 관련 공지
            if let url = URL(string: "https://www.youchu.link/license_information.html") {
                UIApplication.shared.open(url)
            }
        case 7: // 서비스 이용 약관
            if let url = URL(string: "https://www.youchu.link/Service.html") {
                UIApplication.shared.open(url)
            }

        default:
            break
        }
    }
}

extension MyPageController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let _ = error {
                controller.dismiss(animated: true, completion: nil)
                return
            }
            switch result {
            case .cancelled:
                break
            case .failed:
                break
            case .saved:
                break
            case .sent:
                let alert = UIAlertController(title: "메일을 보냈습니다.", message: "소중한 의견 감사합니다.", preferredStyle: UIAlertController.Style.alert)
                present(alert, animated: false, completion: nil)
                break
            @unknown default:
                break
            }
            controller.dismiss(animated: true, completion: nil)
        }
}
