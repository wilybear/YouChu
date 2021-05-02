//
//  RankingController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//


import UIKit

let rankCellIdentifier = "rankCell"

class RankingController: UIViewController {

    var count = 1
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 100
        tv.delegate = self
        tv.dataSource = self
        tv.register(RankingTableViewCell.self, forCellReuseIdentifier: rankCellIdentifier)
        return tv
    }()

    private let header: RankingHeader = {
        let header = RankingHeader(frame: CGRect.zero)
        return header
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Helpers

    private func configureUI(){
        view.addSubview(header)
        header.setHeight(105)
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.anchor(top: header.bottomAnchor, left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

    }
}

// MARK: - UITableViewDelegate, DataSource

extension RankingController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rankCellIdentifier, for: indexPath) as! RankingTableViewCell
        cell.rank = indexPath.row + 1
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChannelDetailController()
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: DumiData

extension RankingController {
    func fetchData() -> [String]{
        return ["승우 아빠", "Black Pink - Official channel"]
    }
}
