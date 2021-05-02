//
//  VideoViewController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/28.
//

import UIKit

class VideoViewController: UITableViewController {
    private static let CellIdentifier = "CellIdentifier"

    // MARK: - Properties

    var videos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        videos = fetchData()
        configureUI()
    }

    // MARK: - LifeCycle

    // MARK: - API

    // MARK: - Helpers
    private func configureUI(){
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoViewController.CellIdentifier)
        tableView.rowHeight = 125
        tableView.separatorStyle = .none
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoViewController.CellIdentifier, for: indexPath) as! VideoTableViewCell
        cell.video = videos[indexPath.row]
        return cell
    }

    private func fetchData() -> [Video]{
        let video1 = Video(thumbnail: #imageLiteral(resourceName: "thumbnail1"), title: "[4K][Special]선우정아(SWJA)의 킬링보이스를 라이브로!ㅣ도망가자, 남, 구애, 뒹굴뒹굴, 고양이, 봄처녀, 쌤쌤, 동거, 백년해로, 그러려니ㅣ딩고뮤직", viewCount: 72039, publishedAt: "2021. 4. 30.")
        let video2 = Video(thumbnail: #imageLiteral(resourceName: "thumbnail2"), title: "[4K] 휘인 (Whee In) - water color | Performance video | CHOREOGRAPHY | MOVE REC. 무브렉ㅣ딩고뮤직ㅣDingo Music", viewCount: 446122, publishedAt: "2021. 4. 14.")
        let video3 = Video(thumbnail: #imageLiteral(resourceName: "thumbnail3"), title: "[4K]❤️비주얼+퍼포먼스+보컬 모두 갓벽하다는❤️STAYC(스테이씨)-ASAPㅣ세로라이브ㅣSERO LIVEㅣ딩고뮤직ㅣDingo Music", viewCount: 542049, publishedAt: "2021. 4. 13.")
        return [video1,video2,video3]
    }

}
