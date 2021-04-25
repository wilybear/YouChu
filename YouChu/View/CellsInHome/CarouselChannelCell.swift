//
//  CarouselChannelCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/17.
//

import UIKit

class CarouselChannelCell: UICollectionViewCell {

    // MARK: - Properties

    private let channelImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "iu")
        return iv
    }()

    private let channelTitle: UILabel = {
        let label = UILabel()
        label.text = "🌻아이유의 산뜻하고, 계속 듣고 싶어지는 노래모음 | PLAYLIST🎵"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(channelImageView)
        channelImageView.fillSuperview()

        addSubview(channelTitle)
        channelTitle.anchor(left: leftAnchor, bottom: channelImageView.bottomAnchor, right: rightAnchor)
        channelImageView.bringSubviewToFront(channelTitle)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
