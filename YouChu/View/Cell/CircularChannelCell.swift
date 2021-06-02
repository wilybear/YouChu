//
//  ChannelCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit

class CircularChannelCell: UICollectionViewCell {

    // MARK: - Properties

    var channel: Channel? {
        didSet {
            channelCell.setImage(url: channel?.thumbnailUrl)
            channelCell.title = channel?.title
        }
    }

    private let channelCell: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 13.adjusted(by: .horizontal), imageSize: 75.adjusted(by: .vertical))
        return cpv
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(channelCell)
        channelCell.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
