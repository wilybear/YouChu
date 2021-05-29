//
//  ChannelCardView.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/18.
//

import UIKit
import ActiveLabel

let tagIdentifier = "SubscriberTag"

protocol ChannelCardViewDelegate: AnyObject {
    func handleDetailButton(_ channelCardView: ChannelCardView)
    func slideInAfterLoading()
}

class ChannelCardView: UIView {

    // MARK: - Properites

    private let containerView = UIView()
    private let cornerRadius: CGFloat = 15.adjusted(by: .vertical)
    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = .blue

    weak var delegate: ChannelCardViewDelegate?

    var channel: Channel? {
        didSet {
            setChannelInfo()
        }
    }

    private let subscriberCount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.adjusted(by: .horizontal))
        return label
    }()

    private lazy var channelProfileView: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 17.adjusted(by: .horizontal), imageSize: 85.adjusted(by: .vertical))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDetailButton))
        cpv.isUserInteractionEnabled = true
        cpv.addGestureRecognizer(tap)
        return cpv
    }()

    private let instructionTitle: UILabel = {
        let label = UILabel()
        label.text = "채널 소개"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18.adjusted(by: .horizontal))
        return label
    }()

    private lazy var instruction: ActiveLabel = {
        let label = ActiveLabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.adjusted(by: .horizontal))
        label.textColor = .darkGray
        label.enabledTypes = [.url]
        label.numberOfLines = 8
        label.handleURLTap { url in
            print(url)
        }
        return label
    }()

    private var keywords: [Keyword] = []

    private let TagListTitle: UILabel = {
        let label = UILabel()
        label.text = "채널 키워드"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18.adjusted(by: .horizontal))
        return label
    }()

    private lazy var DetailButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "search_selected"), for: .normal)
        bt.addTarget(self, action: #selector(handleDetailButton), for: .touchUpInside)
        bt.tintColor = .black
        return bt

    }()

    private lazy var TagListCollectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(TagCell.self, forCellWithReuseIdentifier: tagIdentifier)
        return cv
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setChannelInfo()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.6
            shadowLayer.shadowRadius = 6

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func changeNumbersOfLine(_ sender: UITapGestureRecognizer) {
        instruction.numberOfLines = instruction.numberOfLines == 3 ? 5 : 3
    }

    @objc func handleDetailButton() {
        delegate?.handleDetailButton(self)
    }

    // MARK: - Helpers

    private func configureUI() {
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        containerView.layer.cornerRadius = cornerRadius
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white

        containerView.addSubview(DetailButton)
        DetailButton.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingRight: 15)

        containerView.addSubview(channelProfileView)
        channelProfileView.centerX(inView: containerView)
        channelProfileView.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, paddingTop: 10)

        containerView.addSubview(subscriberCount)
        subscriberCount.anchor(top: channelProfileView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 3)

        containerView.addSubview(instructionTitle)
        instructionTitle.anchor(top: subscriberCount.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)

        containerView.addSubview(instruction)
        instruction.anchor(top: instructionTitle.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingRight: 20)

        containerView.addSubview(TagListTitle)
        TagListTitle.anchor(top: instruction.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        containerView.addSubview(TagListCollectionView)
        TagListCollectionView.centerX(inView: containerView)
        TagListCollectionView.anchor(top: TagListTitle.bottomAnchor, left: leftAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
        // TagListCollectionView.setHeight(CGFloat(30 * (sampleTagData.count / 5) + 50) )

    }

    func setChannelInfo() {
        guard let channel = channel else {
            return
        }
        subscriberCount.text = "구독자 " + channel.subscriberCountText
        channelProfileView.title = channel.title
        instruction.text = channel.description
        Service.fetchKeywordList(channelIdx: channel.channelIdx!, completion: { result in
            guard let keywords = result else {return}
            self.keywords = keywords
            self.TagListCollectionView.reloadData()
        })
        channelProfileView.setImage(url: channel.thumbnailUrl) { _ in
            self.delegate?.slideInAfterLoading()
        }
//        TagListCollectionView.setNeedsLayout()
//        self.containerView.layoutIfNeeded()
    }
}

extension ChannelCardView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagIdentifier, for: indexPath) as! TagCell
        cell.keyword = keywords[indexPath.row].keyword
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.backgroundColor = .mainColor_4
        return cell
    }

}

extension ChannelCardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let item = keywords[indexPath.row].keyword
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.adjusted(by: .horizontal))
        ])
        return CGSize(width: itemSize.width + 10.adjusted(by: .horizontal), height: itemSize.height + 7.adjusted(by: .vertical))
    }
}
