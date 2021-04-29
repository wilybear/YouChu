//
//  ChannelCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit

class ChannelCell: UICollectionViewCell {

    // MARK: - Properties

    private let channelCell: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 14, imageSize: 80)
        cpv.image = #imageLiteral(resourceName: "paka")
        cpv.title = "PAKA"
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
