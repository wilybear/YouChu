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
    var listType: ListType?

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

    init(title: String, channels: [Channel]) {
        self.channels = channels
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    init(title: String, type: ListType) {
        self.listType = type
        super.init(nibName: nil, bundle: nil)
        self.title = title
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
        fetchUsersChannel()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = false
        super.viewWillDisappear(animated)
    }

    // MARK: - API

    func fetchUsersChannel() {
        guard let type = listType else {
            return
        }

        if !NetMonitor.shared.internetConnection {
            var key: String = ""
            if type == .prefer {
                key = "prefer"
            } else if type == .dislike {
                key = "dislike"
            }
            if let channelsJson = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let channels = try? decoder.decode([Channel].self, from: channelsJson) {
                    self.channels = channels
                }
            }
        }

        guard let user = UserInfo.user else {
            return
        }
        switch type {
        case .prefer:
            Service.fetchPreferChannelList(userId: user.id) { response in
                switch response {
                case .success(let data):
                    self.channels = data
                    do {
                        let encoder = JSONEncoder()
                        let encoded = try encoder.encode(data)
                        UserDefaults.standard.set(encoded, forKey: "prefer")
                    } catch let error {
                        print(error)
                    }
                    self.tableView.reloadData()
                case .failure(_):
                    self.dismiss(animated: true, completion: nil)
                }
            }
        case .dislike:
            Service.fetchDislikeChannelList(userId: user.id) { response in
                switch response {
                case .success(let data):
                    self.channels = data
                    do {
                        let encoder = JSONEncoder()
                        let encoded = try encoder.encode(data)
                        UserDefaults.standard.set(encoded, forKey: "dislike")
                    } catch let error {
                        print(error)
                    }
                    self.tableView.reloadData()
                case .failure(_):
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Helpers

    private func configureUI() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
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
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChannelDetailController(channelId: channels[indexPath.row].channelIdx!)
        navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch listType {
            case .prefer:
                Service.deletePreferredChannel(userId: UserInfo.user!.id, channelIdx: channels[indexPath.row].channelIdx!) { response in
                    switch response {
                    case .success(_):
                        self.channels.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(_):
                        break
                    }
                }
            case .dislike:
                Service.deleteDislikedChannel(userId: UserInfo.user!.id, channelIdx: channels[indexPath.row].channelIdx!) { response in
                    switch response {
                    case .success(_):
                        self.channels.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(_):
                        break
                    }
                }
            case .none:
                break
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

enum ListType {
    case prefer, dislike
}
