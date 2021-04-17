//
//  HomeCT.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/17.
//

import UIKit

class HomeCT: UITableViewController {

    // MARK: - Properites

    var category = ["Today's HOT", "Channels you would like", "New Channels"]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: - Helpers

    func configureTableView(){
        view.backgroundColor = .white
        tableView.register(CategoryRow.self, forCellReuseIdentifier: "tableCell")

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 44))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = category[section]
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! CategoryRow

        return cell
    }

}
