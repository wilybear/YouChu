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

    // MARK: - LifeCycle

    // MARK: - API

    // MARK: - Helpers
    private func configureUI(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DetailViewController.CellIdentifier)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 500
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController.CellIdentifier, for: indexPath)
        cell.textLabel?.text = "Title \(indexPath.row)"
        return cell
    }

}
