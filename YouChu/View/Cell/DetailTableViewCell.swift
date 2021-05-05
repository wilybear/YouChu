//
//  DetailTabelViewCell.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/30.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let infoTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let keywordCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        keywordCV.backgroundColor = .clear
        keywordCV.register(TagCell.self, forCellWithReuseIdentifier: tagIdentifier)
        return keywordCV
    }()

    var infoType: String? {
        didSet{
            infoTypeLabel.text = infoType
        }
    }
    var info: String? {
        didSet{
            infoLabel.text = info
        }
    }

    var keywordList: [String]? {
        didSet{
            configureKeywordView()
        }
    }

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

        addSubview(infoTypeLabel)
        infoTypeLabel.anchor(top:topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 10)
        infoTypeLabel.setWidth(80)
        addSubview(infoLabel)
        infoLabel.anchor(top:topAnchor, left: infoTypeLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor ,paddingTop:15, paddingLeft: 10,paddingRight: 15)
    }

    private func configureKeywordView(){
        infoLabel.removeFromSuperview()

        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.anchor(top:topAnchor, left: infoTypeLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor ,paddingTop:15, paddingLeft: 10, paddingRight: 20)
        collectionView.setHeight(CGFloat(30 * (keywordList!.count / 5) + 50) )
        
    }
}

extension DetailTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordList!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagIdentifier, for: indexPath) as! TagCell
        cell.subscriberTag = keywordList![indexPath.row]
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.backgroundColor = .systemBlue
        return cell
    }

}

extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let item = keywordList![indexPath.row]
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)
        ])
        return CGSize(width: itemSize.width + 10, height: itemSize.height + 7)
    }
}