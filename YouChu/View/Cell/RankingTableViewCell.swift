//
//  RankingTableViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/24.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    private let imageSize: CGFloat = 65.adjusted(by: .vertical)

    var channel: Channel? {
        didSet{
            setChannelInfo()
        }
    }

    var rank:Int?{
        didSet{
            rankingLabel.text = String(rank ?? 0)
        }
    }

    // MARK: - Properties
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
        return label
    }()

    private var subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.adjusted(by: .horizontal))
        return label
    }()

    private let rankingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28.adjusted(by: .horizontal))
        return label
    }()

    private lazy var heartImageButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.tintColor = .systemRed
        bt.addTarget(self, action: #selector(preferAction), for: .touchUpInside)
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
        thumbnailImageView.setDimensions(height: imageSize, width: imageSize)
        thumbnailImageView.layer.cornerRadius = imageSize/2
        thumbnailImageView.centerY(inView: contentView)
        thumbnailImageView.anchor(left: rankingLabel.rightAnchor, paddingLeft: 5, paddingRight: 10)

        addSubview(heartImageButton)
        heartImageButton.centerY(inView: contentView)
        heartImageButton.anchor(right: rightAnchor , paddingLeft: 10, paddingRight: 30)

        addSubview(middleStack)
        middleStack.centerY(inView: contentView)
        middleStack.anchor( left: thumbnailImageView.rightAnchor, right: heartImageButton.leftAnchor , paddingLeft: 10, paddingRight: 10)
    }

    func setChannelInfo() {
        guard let channel = channel else {
            return
        }
        thumbnailImageView.sd_setImage(with: channel.thumbnailUrl)
        heartImageButton.setImage(channel.isPreffered ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        nameLabel.text = channel.title
        subscriberCountLabel.text = "구독자 " + channel.subscriberCountText
    }

    // MARK: - Action
    @objc func preferAction(){
        guard let channel = channel else { return }
        guard let user = UserInfo.user else { return }
        heartImageButton.isUserInteractionEnabled = false
        if channel.isPreffered {
            Service.deletePreferredChannel(userId: user.id , channelIdx: channel.channelIdx!) { response in
                switch response {
                case .success(_):
                    self.heartImageButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.channel?.isPreffered = false
                case .failure(_):
                    break
                }
                self.heartImageButton.isUserInteractionEnabled = true
            }
        }else{
            Service.updatePreferredChannel(userId: user.id , channelIdx: channel.channelIdx!) { response in
                switch response {
                case .success(_):
                    self.heartImageButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.channel?.isPreffered = true
                case .failure(_):
                    break
                }
                self.heartImageButton.isUserInteractionEnabled = true
            }
        }

    }
}


