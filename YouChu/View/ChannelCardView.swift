//
//  ChannelCardView.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/18.
//

import UIKit
import ActiveLabel

let tagIdentifier = "SubscriberTag"

class ChannelCardView: UIView {

    // MARK: - Properites

    private let containerView = UIView()
    private let cornerRadius: CGFloat = 15.0
    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = .blue

//    private let channelTitle: UILabel = {
//        let label = UILabel()
//        label.text = "승우아빠"
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 17)
//        return label
//    }()
    private let subscriberCount: UILabel = {
        let label = UILabel()
        label.text = "구독자 140만명"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

//    private let channelImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.image = #imageLiteral(resourceName: "sougu")
//        return iv
//    }()

    private let channelProfileView: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 17, imageSize: 100)
        cpv.image = #imageLiteral(resourceName: "sougu")
        cpv.title = "승우아빠"
        return cpv
    }()

    private let instructionTitle: UILabel = {
        let label = UILabel()
        label.text = "채널 소개"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var instruction: ActiveLabel = {
        let label = ActiveLabel()
        label.text = """
눈으로 보기만 할수 있는 채널이 아닌,
그냥 스쳐 지나가는 어려운 레시피가 아닌,
누구나 따라할 수 있는 레시피 채널을 만들고 싶어요!

*https://www.twitch.tv/swab85
"""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.enabledTypes = [.url]
//        let truncString = "...더보기"
//        var trunc = NSMutableAttributedString(string: truncString)
//        trunc.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 11), range: NSMakeRange(0, truncString.count))
//        trunc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0, truncString.count))

        label.numberOfLines = 8
        label.handleURLTap { url in
            print(url)
        }
        return label
    }()

    private let sampleTagData = ["승우아빠", "요리", "국진화", "레시피","철원"]

    private let TagListTitle: UILabel = {
        let label = UILabel()
        label.text = "구독자 반응 태그"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
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

    @objc func handleDetailButton(){

    }

    // MARK: - Helpers

    private func configureUI(){
        addSubview(containerView)
        containerView.anchor(top:topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white

        containerView.addSubview(DetailButton)
        DetailButton.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingRight: 15)

//        containerView.addSubview(channelImageView)
//        channelImageView.setDimensions(height: imageSize, width: imageSize)
//        channelImageView.layer.cornerRadius = imageSize/2
//        channelImageView.centerX(inView: containerView)
//        channelImageView.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
//
//        containerView.addSubview(channelTitle)
//        channelTitle.anchor(top: channelImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)

        containerView.addSubview(channelProfileView)
        channelProfileView.centerX(inView: containerView)
        channelProfileView.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, paddingTop: 10)


        containerView.addSubview(subscriberCount)
        subscriberCount.anchor(top: channelProfileView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 3)


        containerView.addSubview(instructionTitle)
        instructionTitle.anchor(top: subscriberCount.bottomAnchor, left: leftAnchor,right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)

        containerView.addSubview(instruction)
        instruction.anchor(top: instructionTitle.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingRight: 20)

        containerView.addSubview(TagListTitle)
        TagListTitle.anchor(top: instruction.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        containerView.addSubview(TagListCollectionView)
        TagListCollectionView.centerX(inView: containerView)
        TagListCollectionView.anchor(top: TagListTitle.bottomAnchor, left: leftAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: rightAnchor ,paddingTop: 5, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)

    }

}

extension ChannelCardView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleTagData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagIdentifier, for: indexPath) as! TagCell
        cell.subscriberTag = sampleTagData[indexPath.row]
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.backgroundColor = .systemBlue
        return cell
    }


}

extension ChannelCardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let item = sampleTagData[indexPath.row]
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)
        ])
        return CGSize(width: itemSize.width + 10, height: itemSize.height + 7)
    }
}
