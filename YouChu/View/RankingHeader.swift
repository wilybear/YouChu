//
//  RankingHeader.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/24.
//

import UIKit
import DropDown

class RankingHeader: UIView {

    var category: String = "전체" {
        didSet{
            categoryBtn.setTitle(category, for: .normal)
        }
    }

    // MARK: - Properties
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()

    private lazy var categoryBtn: UIButton = {
        let bt = UIButton(type: .system)
        bt.backgroundColor = .clear
        bt.setTitle(category, for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.addTarget(self, action: #selector(dropCategoryMenu), for: .touchUpInside)
        return bt
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var categoryMenu: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = Category.allCases.map{$0.rawValue}
        dropDown.width = 200
        dropDown.height = 300
        dropDown.cornerRadius = 10
        dropDown.backgroundColor = .white
        dropDown.direction = .bottom

        return dropDown
    }()



    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        categoryBtn.layoutIfNeeded()
        categoryMenu.bottomOffset = CGPoint(x: 0, y:(categoryMenu.anchorView?.plainView.bounds.height)!)
    }


    // MARK: - Helpers

    func configureUI(){
        addSubview(container)
        container.fillSuperview()
        container.clipsToBounds = true
        container.layer.cornerRadius = 15

        container.addSubview(categoryBtn)
        categoryBtn.centerY(inView: container)
        categoryBtn.anchor(left: container.leftAnchor,paddingLeft: 20)

        container.addSubview(categoryLabel)
        categoryLabel.anchor(left:leftAnchor, bottom: categoryBtn.topAnchor, paddingLeft: 20)

        container.addSubview(categoryMenu)
        categoryMenu.anchorView = categoryBtn
        let btnSize = category.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)
        ])
        categoryMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            category = item
        }

    }

    // MARK: - Actions

    @objc func dropCategoryMenu(){
        categoryMenu.show()
    }



}
