//
//  MyPageController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit

let mypageCellIdentifier = "mypageCell"

class MyPageController: UIViewController {

    private let mypageTitle = ["버전 정보","문의하기","리뷰 작성하기","구독 채널 동기화하기","회원 탈퇴"];

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
        iv.image = #imageLiteral(resourceName: "google")
        return iv
    }()

    private let gmailAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "pokari237@gmail.com"
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16.adjusted(by: .horizontal))
        return label
    }()

    private let logoutButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("로그아웃", for: .normal)
        let color = UIColor.systemRed.withAlphaComponent(0.8)
        bt.setTitleColor(color, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14.adjusted(by: .horizontal))
        return bt
    }()

    private lazy var accountStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [googleLogoView,gmailAddressLabel,logoutButton])
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()

    private lazy var channelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [preferedLabel,dislikedLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20.adjusted(by: .horizontal)
        stack.setDimensions(height: 75.adjusted(by: .vertical), width: view.frame.width - 60.adjusted(by: .horizontal))
        preferedLabel.attributedText = attributedStatText(value: 35, label: "선호 채널")
        preferedLabel.setHeight(75)
        dislikedLabel.attributedText = attributedStatText(value: 35, label: "비선호 채널")
        dislikedLabel.setHeight(75)

        return stack
    }()



    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helpers
    private func configureUI(){
        let bgColor = UIColor.systemGray6.withAlphaComponent(0.6)
        view.backgroundColor = bgColor

        navigationItem.title = "내 정보"
        view.addSubview(accountStack)

        googleLogoView.setDimensions(height: 20, width: 20, by: .horizontal)
        accountStack.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)

        view.addSubview(channelStack)
        channelStack.centerX(inView: view)
        channelStack.anchor(top:accountStack.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20,paddingLeft: 30, paddingRight: 30)

        view.addSubview(tableView)
        tableView.centerX(inView: view)
        tableView.anchor(top: channelStack.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30 )
        tableView.setHeight(CGFloat(54 * mypageTitle.count))
        
    }
    private func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.adjusted(by: .vertical)
        paragraphStyle.alignment = .center
        let attributedText = NSMutableAttributedString(string: "\(value)\n",attributes: [.font:UIFont.boldSystemFont(ofSize: 17.adjusted(by: .horizontal))])
        attributedText.append(NSAttributedString(string: label,attributes: [.font:UIFont.systemFont(ofSize: 17.adjusted(by: .horizontal)), .foregroundColor: UIColor.lightGray]))
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        return attributedText
    }

    // MARK: - Actions
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let controller = ChannelListController()
        navigationController?.pushViewController(controller, animated: true)
    }


}


// MARK: - TableViewDelegate, DataSource

extension MyPageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: mypageCellIdentifier, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        cell.title = mypageTitle[indexPath.row]
        if indexPath.row == 0 { cell.addVersionInfo() }

        return cell

    }


}
