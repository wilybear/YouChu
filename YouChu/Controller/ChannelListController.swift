//
//  ChannelListController.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit

class ChannelListController: UIViewController {
    private static let CellIdentifier = "ChannerlIdentifier"
    // MARK: - Properties

    var channels: [Channel] = []

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 100
        tv.delegate = self
        tv.dataSource = self
        tv.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelListController.CellIdentifier)
        return tv
    }()


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        channels = fetchData()
        configureUI()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "선호채널"
    }

    // MARK: - API

    // MARK: - Helpers

    private func configureUI(){
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }

    private func fetchData() -> [Channel]{
        [
            Channel(thumbnail: #imageLiteral(resourceName: "yebit"), channelName: "Yebit 예빛", subscriberCount: 27, isprefered: true),
            Channel(thumbnail: #imageLiteral(resourceName: "sougu"), channelName: "승우아빠", subscriberCount: 141, isprefered: true),
            Channel(thumbnail: #imageLiteral(resourceName: "dingo"), channelName: "딩고 뮤직 / dingo music", subscriberCount: 293, isprefered: true),
            Channel(thumbnail: #imageLiteral(resourceName: "paka"), channelName: "PAKA", subscriberCount: 28, isprefered: true),

        ]
    }

    // MARK: - Actions


}

extension ChannelListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelListController.CellIdentifier, for: indexPath) as! ChannelTableViewCell
        cell.channel = channels[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChannelDetailController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

