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

    var channel: Channel? {
        didSet {
            fetchVideos()
        }
    }
    var videos: [Video] = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - API
    func fetchVideos() {
        guard let channel = channel else {
            return
        }

        Service.fetchLatestVideos(of: channel.channelId!) { result in
            switch result {
            case .success(let videos):
                self.videos = videos
                self.tableView.reloadData()
            case .failure(let err):
                self.showMessage(withTitle: "Err", message: "\(err)")
            }
        }
    }

    // MARK: - Helpers
    private func configureUI() {
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoViewController.CellIdentifier)
        tableView.rowHeight = 125.adjusted(by: .vertical)
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
}

extension VideoViewController: VideoDelegate {
    func openYoutubeVideo(index: Int) {
        guard let videoId = videos[index].videoId else {
            return
        }
        let appURL = NSURL(string: "youtube://www.youtube.com/watch?v=" + videoId)!
        let webURL = NSURL(string: "https://www.youtube.com/watch?v=" + videoId)!
        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
}
