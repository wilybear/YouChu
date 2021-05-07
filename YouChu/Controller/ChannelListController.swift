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
        tv.rowHeight = 100.adjusted(by: .vertical)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelListController.CellIdentifier)
        return tv
    }()


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        channels = Test.fetchData()
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            channels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

