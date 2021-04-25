//
//  RankingTableViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/24.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "sougu")
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "승우 아빠"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private let subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "구독자 140만명"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private let rankingLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()

    private let heartImageButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        bt.tintColor = .systemRed
        return bt
    }()


    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    func configureUI(){
        let middleStack = UIStackView(arrangedSubviews: [nameLabel, subscriberCountLabel])
        middleStack.axis = .vertical
        middleStack.distribution = .fill
        middleStack.spacing = 15
        middleStack.alignment = .leading
        

        addSubview(rankingLabel)
        rankingLabel.setWidth(50)
        rankingLabel.centerY(inView: contentView)
        rankingLabel.anchor(left: leftAnchor, paddingLeft: 15, paddingRight: 5)

        addSubview(thumbnailImageView)
        thumbnailImageView.setDimensions(height: 80, width: 80)
        thumbnailImageView.layer.cornerRadius = 80/2
        thumbnailImageView.centerY(inView: contentView)
        thumbnailImageView.anchor(left: rankingLabel.rightAnchor, paddingLeft: 5, paddingRight: 10)

        addSubview(heartImageButton)
        heartImageButton.centerY(inView: contentView)
        heartImageButton.anchor(right: rightAnchor , paddingLeft: 10, paddingRight: 30)

        addSubview(middleStack)
        middleStack.centerY(inView: contentView)
        middleStack.anchor( left: thumbnailImageView.rightAnchor, right: heartImageButton.leftAnchor , paddingLeft: 10, paddingRight: 10)


    }

}


