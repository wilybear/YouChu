//
//  DetailTabelViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/30.
//

import UIKit
import ActiveLabel

protocol TagCellDelegate: AnyObject {
    func didSelect(keyword: String)
}

class DetailTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let infoTypeLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.adjusted(by: .horizontal))
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        return label
    }()

    private lazy var infoLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15.adjusted(by: .horizontal))
        label.textColor = .darkGray
        label.enabledTypes = [.url]
        label.numberOfLines = 0
        label.handleURLTap { url in
            UIApplication.shared.open(url)
        }
        label.isUserInteractionEnabled = true
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let keywordCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        keywordCV.backgroundColor = .clear
        keywordCV.register(TagCell.self, forCellWithReuseIdentifier: tagIdentifier)
        keywordCV.isUserInteractionEnabled = false
        return keywordCV
    }()

    var infoType: String? {
        didSet {
            infoTypeLabel.text = infoType
        }
    }
    var info: String? {
        didSet {
            infoLabel.text = info
        }
    }

    var keywordList: [Keyword]? {
        didSet {
            collectionView.reloadData()
            configureKeywordView()
        }
    }

    var keywordHeightContraint: NSLayoutConstraint?

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func configureUI() {

        addSubview(infoTypeLabel)
        infoTypeLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 10)
        infoTypeLabel.setWidth(90.adjusted(by: .horizontal))
        addSubview(infoLabel)
        infoLabel.anchor(top: topAnchor, left: infoTypeLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 15)
    }

    private func configureKeywordView() {
        infoLabel.removeFromSuperview()
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        if let contraint = keywordHeightContraint {
            contraint.isActive = false
        }
        collectionView.anchor(top: topAnchor, left: infoTypeLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 20)
        collectionView.setNeedsLayout()
        layoutIfNeeded()
        keywordHeightContraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
        keywordHeightContraint?.isActive = true
        collectionView.setNeedsLayout()
        layoutIfNeeded()
        contentView.layoutIfNeeded()
    }
}

extension DetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordList!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagIdentifier, for: indexPath) as! TagCell
        cell.keyword = keywordList![indexPath.row].keyword
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.backgroundColor = .mainColor_3
        return cell
    }

}

extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let item = keywordList![indexPath.row].keyword
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.adjusted(by: .horizontal))
        ])
        return CGSize(width: itemSize.width + 10.adjusted(by: .horizontal), height: itemSize.height + 7.adjusted(by: .vertical))
    }
}
