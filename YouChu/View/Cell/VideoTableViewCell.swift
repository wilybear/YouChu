//
//  VideoTableViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/02.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    // MARK: - Properties

    var video: Video? {
        didSet{
            setVideosInfos()
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.adjusted(by: .horizontal))
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.adjusted(by: .horizontal))
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
        label.font = UIFont.systemFont(ofSize: 14.adjusted(by: .horizontal))
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
        thumbnailImageView.setWidth(200.adjusted(by: .horizontal))
        thumbnailImageView.anchor(top:topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10)

        addSubview(titleLabel)
        titleLabel.anchor(top:topAnchor, left: thumbnailImageView.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10,paddingRight: 20)
        addSubview(publishedAtLabel)
        publishedAtLabel.anchor(top:titleLabel.bottomAnchor, left: thumbnailImageView.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 20)
        addSubview(viewCountLabel)
        viewCountLabel.anchor(top: publishedAtLabel.bottomAnchor, left: thumbnailImageView.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 20)

    }

    private func setVideosInfos(){
        guard let video = video else { return }
        titleLabel.text = video.title
        thumbnailImageView.image = video.thumbnail
        publishedAtLabel.text = video.publishedAt
        viewCountLabel.text = "조회수 \(video.viewCount)회"
    }
}
