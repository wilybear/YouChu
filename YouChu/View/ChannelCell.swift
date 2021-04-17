//
//  ChannelCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit

class ChannelCell: UICollectionViewCell {

    // MARK: - Properties

    private let channelImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "paka")
        return iv
    }()

    private let channelTitle: UILabel = {
        let label = UILabel()
        label.text = "PAKA"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(channelImageView)
        channelImageView.setDimensions(height: 70, width: 70)
        channelImageView.layer.cornerRadius = 70/2
        channelImageView.centerX(inView: contentView)
        channelImageView.centerY(inView: contentView)

        addSubview(channelTitle)
        channelTitle.anchor(top: channelImageView.bottomAnchor, left: leftAnchor, right: rightAnchor)



    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
