//
//  CarouselChannelCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/17.
//

import UIKit

class CarouselChannelCell: UICollectionViewCell {

    // MARK: - Properties

    private let imageSize: CGFloat = 85.adjusted(by: .vertical)

    var channel: Channel? {
        didSet{
            setUpChannelInfo()
        }
    }

    private lazy var bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.7
        iv.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        return iv
    }()

    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17.adjusted(by: .horizontal))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .white
        return label
    }()

    private let subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.adjusted(by: .horizontal))
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        let middleStack = UIStackView(arrangedSubviews: [nameLabel, subscriberCountLabel])
        middleStack.axis = .vertical
        middleStack.distribution = .fill
        middleStack.spacing = 5.adjusted(by: .horizontal)
        middleStack.alignment = .leading
        
        backgroundColor = .white
        addSubview(bannerImageView)
        bannerImageView.fillSuperview()

        thumbnailImageView.setDimensions(height: imageSize, width: imageSize)
        thumbnailImageView.layer.cornerRadius = imageSize/2
        addSubview(thumbnailImageView)
        thumbnailImageView.centerY(inView: contentView, leftAnchor: leftAnchor, paddingLeft: 20)
        addSubview(middleStack)
        middleStack.centerY(inView: contentView, leftAnchor: thumbnailImageView.rightAnchor, paddingLeft: 10)
        middleStack.anchor(right: rightAnchor, paddingRight: 15)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func setUpChannelInfo(){
        guard let channel = channel else {
            return
        }
        thumbnailImageView.sd_setImage(with: channel.thumbnailUrl)
        nameLabel.text = channel.title
        subscriberCountLabel.text = "구독자 " + channel.subscriberCountText
        bannerImageView.sd_setImage(with: channel.bannerImageUrl)
    }
}
