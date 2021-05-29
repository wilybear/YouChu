//
//  MyPageTableCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/27.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.adjusted(by: .horizontal))
        return label
    }()

    private let arrow: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    var title: String? {
        didSet {
            name.text = title
        }
    }

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func configureUI() {
        addSubview(name)
        name.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingLeft: 15)
        addSubview(arrow)
        arrow.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 15)
    }

    func addVersionInfo() {
        arrow.removeFromSuperview()
        let versionLabel = UILabel()
        versionLabel.textColor = UIColor.lightGray
        versionLabel.text = "1.0.0"
        versionLabel.font = UIFont.systemFont(ofSize: 17.adjusted(by: .horizontal))
        addSubview(versionLabel)
        versionLabel.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 15)
    }

}
