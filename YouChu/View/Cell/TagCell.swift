//
//  File.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/23.
//

import UIKit

class TagCell: UICollectionViewCell {

    // MARK: - Properties
    var subscriberTag: String? {
        didSet{
            tagLabel.text = subscriberTag
        }
    }

    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
    
        label.textColor = .white

        return label
    }()


    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func configureUI(){
        addSubview(tagLabel)
        tagLabel.text = subscriberTag ?? ""
        tagLabel.center(inView: contentView)
    }
}