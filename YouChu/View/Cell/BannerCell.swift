//
//  ChannelCell.swift
//  YouChu
//
//  Created by κΉνμ on 2021/04/15.
//

import UIKit

class BannerCell: UICollectionViewCell {

    // MARK: - Properties
    var bannerImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bannerImage)
        bannerImage.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
