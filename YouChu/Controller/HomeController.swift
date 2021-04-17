//
//  HomeController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit


let firstIdentifier = "first"
let secondIdentifier = "second"

class HomeController: UIViewController {

    // MARK: - Properties

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 5
        let padding: CGFloat = 6
        layout.scrollDirection = .horizontal
        //layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/itemsPerRow, height: 100)
        return layout
    }()

    lazy var collectionViewOne:UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.setCollectionViewLayout(layout, animated: true)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ChannelCell.self, forCellWithReuseIdentifier: firstIdentifier)

        return cv
    }()
//    let layout2 = UICollectionViewFlowLayout()
//    private lazy var collectionViewTwo = UICollectionView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200), collectionViewLayout: layout2)


    // TODO: custom view로 만들기
    private let labelForFirstCollectionView: UILabel = {
        let label = UILabel()
        label.text = "요즘 핫한 채널"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private let labelForSecondCollectionView: UILabel = {
        let label = UILabel()
        label.text = "00과 비슷한 채널"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }

    // MARK: - Helpers

    func configureUI(){

        view.addSubview(labelForFirstCollectionView)

        labelForFirstCollectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 15)

        view.addSubview(self.collectionViewOne)
        collectionViewOne.anchor(top: labelForFirstCollectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 15)
        collectionViewOne.setHeight(100)

        view .addSubview(labelForSecondCollectionView)
        labelForSecondCollectionView.anchor(top:collectionViewOne.bottomAnchor, left: view.leftAnchor, paddingLeft: 15)



    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // first collectionview
//        if collectionView == self.collectionViewOne {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstIdentifier, for: indexPath as IndexPath) as! ChannelCell
            return cell
//        }
//        else if collectionView == self.collectionViewTwo {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondIdentifier, for: indexPath) as UICollectionViewCell
//            return cell
//        }
 //       return UICollectionViewCell()
    }

}

