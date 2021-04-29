//
//  DetailPageView.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/29.
//

import UIKit
import Parchment

class ChannelDetailPagingView: PagingView {

    // MARK: - Properties
    static let HeaderHeight: CGFloat = 300

    var headerHeightConstraint: NSLayoutConstraint?

    private lazy var bannerImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "dingo_banner")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private lazy var thumbnailImageView: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 20, imageSize: imageSize)
        cpv.image = #imageLiteral(resourceName: "dingo")
        cpv.title = "딩고 뮤직 / dingo music"
        return cpv
    }()

    private lazy var container = UIView()

    // MARK: - Lifecycle

    override func setupConstraints() {
        addSubview(container)
        container.backgroundColor = .systemGreen
        container.clipsToBounds = true
        container.addSubview(bannerImage)
        bannerImage.heightAnchor.constraint(lessThanOrEqualToConstant: 225).isActive = true
        bannerImage.anchor(top:container.topAnchor, left: container.leftAnchor, right: container.rightAnchor)
        container.addSubview(thumbnailImageView)
        thumbnailImageView.centerX(inView: container)
        thumbnailImageView.anchor(top: bannerImage.bottomAnchor, paddingTop: -imageSize/2)

        headerHeightConstraint = container.heightAnchor.constraint(equalToConstant: ChannelDetailPagingView.HeaderHeight)

        headerHeightConstraint?.isActive = true

        collectionView.anchor(top: container.bottomAnchor, left: leftAnchor, right: rightAnchor, height: options.menuHeight)
        container.anchor(top:safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor)

        pageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

}


class HeaderPagingViewController: PagingViewController {
    override func loadView() {
        view = ChannelDetailPagingView(options: options, collectionView: collectionView, pageView: pageViewController.view)
    }
}
