//
//  CircularImageView.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/26.
//

import UIKit

class CircularProfileView: UIView {

    // MARK: - Properties
    private let channelImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()

    private let channelTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    var fontSize: CGFloat

    var image: UIImage?{
        didSet{
            channelImageView.image = image
        }
    }
    var title: String? {
        didSet{
            channelTitle.text = title
        }
    }
    var imageSize: CGFloat


    // MARK: - LifeCycle

    init(fontSize: CGFloat = 24, imageSize: CGFloat = 80 ){
        self.fontSize = fontSize
        self.imageSize = imageSize
        super.init(frame: CGRect.zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func configureUI(){
        addSubview(channelImageView)
        channelImageView.centerX(inView: self)
        addSubview(channelTitle)

        channelTitle.font = UIFont.boldSystemFont(ofSize: fontSize)
        channelImageView.setDimensions(height: imageSize, width: imageSize)
        channelImageView.layer.cornerRadius = imageSize/2
        channelTitle.anchor(top: channelImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
        self.anchor(top:channelImageView.topAnchor, bottom: channelTitle.bottomAnchor)
    }

    func setImage(url: URL?){
        channelImageView.sd_setImage(with: url)
    }

    // MARK: - Actions

}
