//
//  DetailViewController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/28.
//

import UIKit
import ActiveLabel

class DetailViewController: UITableViewController {
    private static let CellIdentifier = "CellIdentifier"

    // MARK: - Properties
    var channel: Channel? {
        didSet{
            configureChannelInfo()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private let infoTypeList = [
        "채널 이름",
        "채널 생성일",
        "구독자 수",
        "총 영상 수",
        "총 조회 수",
        "카테고리",
        "키워드" ,
        "채널 소개"
    ]

    // TODO: should be channed to view model
    private var infoList:[String?] = []

    private var keywordList:[Keyword] = []

    // MARK: - LifeCycle

    // MARK: - API
    func configureChannelInfo(){
        guard let channel = channel else {
            return
        }
        infoList = [
            channel.title,
            channel.publishedAt,
            channel.subscriberCount?.addComma(),
            channel.videoCount?.addComma(),
            channel.viewCount?.addComma(),
            "",
            "",
            channel.description
        ]

        Service.fetchTopics(of: channel.channelIdx!) { topics in
            guard let topics = topics else { return }
            let topicNames = topics.map{$0.topicName}
            self.infoList[5] = topicNames.joined(separator: "/")
            self.tableView.reloadData()
        }

        Service.fetchKeywordList(channelIdx: channel.channelIdx!) { results in
            guard let results = results else { return }
            self.keywordList = results
            self.tableView.reloadData()
        }

    }

    // MARK: - Helpers
    private func configureUI(){
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailViewController.CellIdentifier)
        tableView.estimatedRowHeight = 30.adjusted(by: .vertical)
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.anchor(paddingTop: 30)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return infoTypeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController.CellIdentifier, for: indexPath) as! DetailTableViewCell
        cell.infoType = infoTypeList[indexPath.row]
        cell.info = infoList.isEmpty ? "" : infoList[indexPath.row]
        if cell.info == nil {
            cell.infoType = ""
        }
        if infoTypeList[indexPath.row] == "키워드" {
            cell.keywordList = keywordList
            if keywordList.isEmpty {
                cell.infoType = ""
            }
        }
        return cell
    }
}
