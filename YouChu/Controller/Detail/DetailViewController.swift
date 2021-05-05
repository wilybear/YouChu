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
    private let infoList = [
        "딩고 뮤직 / dingo music",
        "2015-02-11",
        "2930000",
        "1495",
        "1054198288",
        "Pop Music / Music of Asia / Entertaiment / Music",
        "",
        "소셜 모바일 세대를 위한 딩고 Dingo의 대표 음악채널 딩고 뮤직(Dingo Music). \n세로 라이브, 이슬 라이브 등 음악 라이브와 댄스, 예능 컨텐츠 등 단독 공개! \n\nCopyright 2015 MakeUs Co.,Ltd. All rights reserved"
    ]

    private let keywordList = ["MV", "KPOP", "멜론" ,"melon","가수" ,"아이돌", "음악", "music dingo", "딩고" ,"딩고뮤직", "dingomusic"]

    // MARK: - LifeCycle

    // MARK: - API

    // MARK: - Helpers
    private func configureUI(){
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailViewController.CellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.anchor(paddingTop: 30)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return infoTypeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController.CellIdentifier, for: indexPath) as! DetailTableViewCell
        cell.infoType = infoTypeList[indexPath.row]
        cell.info = infoList[indexPath.row]
        if infoTypeList[indexPath.row] == "키워드" {
            cell.keywordList = keywordList
        }
        return cell
    }

}

