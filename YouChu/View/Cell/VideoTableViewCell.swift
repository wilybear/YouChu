//
//  VideoTableViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit
import SDWebImage

class VideoTableViewCell: UITableViewCell {

    // MARK: - Properties

    var video: Video? {
        didSet{
            setVideosInfos()
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.adjusted(by: .horizontal))
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.adjusted(by: .horizontal))
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()

    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let publishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.adjusted(by: .horizontal))
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
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

    private func configureUI(){

        addSubview(thumbnailImageView)
        thumbnailImageView.centerY(inView: contentView)
        thumbnailImageView.setWidth(186.adjusted(by: .vertical))
        thumbnailImageView.anchor(top:topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeft: 15 ,paddingBottom: 10)

        addSubview(titleLabel)
        titleLabel.anchor(top:topAnchor, left: thumbnailImageView.rightAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10,paddingRight: 15)
        addSubview(publishedAtLabel)
        publishedAtLabel.anchor(left: thumbnailImageView.rightAnchor,right: rightAnchor, paddingLeft: 10, paddingRight: 15)
        addSubview(viewCountLabel)
        viewCountLabel.anchor(top: publishedAtLabel.bottomAnchor, left: thumbnailImageView.rightAnchor, bottom: bottomAnchor,right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 15, paddingRight: 15)

    }

    private func setVideosInfos(){
        guard let video = video else { return }
        titleLabel.text = video.title
        thumbnailImageView.sd_setImage(with: video.thumbnailUrl)
        publishedAtLabel.text = video.publishedAt
        viewCountLabel.text = "조회수 "+video.viewCountText+"회"
    }
}
