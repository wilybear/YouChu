//
//  ChannelTableViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit
import SDWebImage

class ChannelTableViewCell: UITableViewCell {

    private let imageSize: CGFloat = 70.adjusted(by: .vertical)

    var channel : Channel? {
        didSet{
            setUpChannelInfo()
        }
    }

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
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17.adjusted(by: .horizontal))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private let subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.adjusted(by: .horizontal))
        return label
    }()

    private let heartImageButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "heart"), for: .normal)
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
        middleStack.spacing = 15.adjusted(by: .horizontal)
        middleStack.alignment = .leading

        addSubview(thumbnailImageView)
        thumbnailImageView.setDimensions(height: imageSize, width: imageSize)
        thumbnailImageView.layer.cornerRadius = imageSize/2
        thumbnailImageView.centerY(inView: contentView)
        thumbnailImageView.anchor(left: leftAnchor, paddingLeft: 15, paddingRight: 10)

        addSubview(middleStack)
        middleStack.centerY(inView: contentView)
        middleStack.anchor( left: thumbnailImageView.rightAnchor, right: rightAnchor , paddingLeft: 20, paddingRight: 20)
    }

    private func setUpChannelInfo(){
        guard let channel = channel else {
            return
        }
        thumbnailImageView.sd_setImage(with: channel.thumbnailUrl)
        nameLabel.text = channel.title
        subscriberCountLabel.text = "구독자 \(String(describing: channel.subscriberCount))만명"
        if channel.isPreffered {
            heartImageButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }

    }

}



