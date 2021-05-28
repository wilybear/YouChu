//
//  ChannelListNEViewController.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/22.
//

import UIKit

class ChannelListNEViewController: UIViewController {
    private static let CellIdentifier = "NEId"
    // MARK: - Properties

    var channels: [Channel] = []
    var listType: ChannelListType
    var currentPage = 1
    var isLastPage = false
    var isPaging = false
    var keyword: String?

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 100.adjusted(by: .vertical)
        tv.delegate = self
        tv.dataSource = self
        tv.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelListNEViewController.CellIdentifier)
        return tv
    }()


    // MARK: - LifeCycle

    init(title: NSMutableAttributedString, channels: [Channel], type: ChannelListType){
        self.channels = channels
        listType = type
        super.init(nibName: nil, bundle: nil)
        let titleLabel = UILabel()
        titleLabel.attributedText = title
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        super.viewWillDisappear(animated)
    }

    // MARK: - API

//    func fetchChannels(page: Int){
//        guard let user = UserInfo.user else {
//            return
//        }
//        showLoader(true)
//        isPaging = true
//        switch listType {
//        case .recommended:
//            Service.fetchRecommendChannelList(userId: user.id, size: 10, page: page) { result in
//                switch result {
//                case .success(let page):
//                    self.channels.append(contentsOf: page.data ?? [])
//                    self.tableView.reloadData()
//                    if page.last{
//                        self.isLastPage = true
//                        self.isPaging = false
//                        self.showLoader(false)
//                    }
//                    self.currentPage += 1
//                    self.isPaging = false
//                    self.showLoader(false)
//                case .failure(let err):
//                    self.showMessage(withTitle: "Err", message: "\(err)")
//                    self.isPaging = false
//                    self.showLoader(false)
//                }
//            }
//        case .related:
//            Service.fetchRelatedChannels(userId: user.id, size: 10, page: page) { result, standvalue  in
//                switch result {
//                case .success(let page):
//                    self.channels.append(contentsOf: page.data ?? [])
//                    self.tableView.reloadData()
//                    if page.last{
//                        self.isLastPage = true
//                        self.isPaging = false
//                        self.showLoader(false)
//                    }
//                    self.currentPage += 1
//                    self.isPaging = false
//                    self.showLoader(false)
//                case .failure(let err):
//                    self.showMessage(withTitle: "Err", message: "\(err)")
//                    self.isPaging = false
//                    self.showLoader(false)
//                }
//            }
//        }
//    }

    // MARK: - Helpers

    private func configureUI(){
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if !channels.isEmpty
        {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "채널이 존재하지 않습니다."
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    // MARK: - Actions

}

extension ChannelListNEViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelListNEViewController.CellIdentifier, for: indexPath) as! ChannelTableViewCell
        cell.channel = channels[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChannelDetailController(channelId: channels[indexPath.row].channelIdx!)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChannelListNEViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        if offsetY > (contentHeight - height) {
            if isPaging == false && !isLastPage {
            //   fetchChannels(page: currentPage)
            }
        }
    }
}

enum ChannelListType{
    case recommended, related
}
