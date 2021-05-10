//
//  HomeController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit
import GoogleSignIn

let bannerIdentifier = "banner"
let circularIdentifier = "circular"
let carouselIdentifier = "carousel"

class HomeController: UIViewController {

    // MARK: - Properties

    var currentIdx: CGFloat = 0.0

    var timer = Timer()
    var counter = 0

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = bannerImages.count
        pc.currentPage = 0
        return pc
    }()

    private var bannerImages = [
        UIImage(named: "banner"),
        UIImage(named: "iu"),
        UIImage(named: "banner"),
        UIImage(named: "banner")
    ]

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width , height: 250)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.setCollectionViewLayout(layout, animated: true)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(BannerCell.self, forCellWithReuseIdentifier: bannerIdentifier)

        return cv
    }()

    lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 80, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.setCollectionViewLayout(layout, animated: true)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(CarouselChannelCell.self, forCellWithReuseIdentifier: carouselIdentifier)

        return cv
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 5
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 5, right: 20)
        layout.itemSize = CGSize(width: (view.frame.width - 5)/itemsPerRow, height: 100)
        return layout
    }()

    lazy var circularCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.setCollectionViewLayout(layout, animated: true)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.register(ChannelCell.self, forCellWithReuseIdentifier: circularIdentifier)

        return cv
    }()


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
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "유추"

    }

    // MARK: - Actions

    @objc func changeImage(){
        if counter < bannerImages.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredVertically, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }

    // MARK: - Helpers

    func configureUI(){

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchor(top:view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.centerX(inView: view)

        contentView.anchor(top:scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.centerX(inView: scrollView)

        contentView.addSubview(bannerCollectionView)
        bannerCollectionView.setHeight(250)
        bannerCollectionView.anchor(top:contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)

        contentView.addSubview(pageControl)
        pageControl.anchor(left: contentView.leftAnchor, bottom: bannerCollectionView.bottomAnchor, right: contentView.rightAnchor, paddingBottom: 10)

        contentView.addSubview(labelForFirstCollectionView)

        labelForFirstCollectionView.anchor(top:bannerCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 30, paddingLeft: 15)

        contentView.addSubview(circularCollectionView)
        circularCollectionView.setHeight(115)
        circularCollectionView.anchor(top: labelForFirstCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10)

        contentView.addSubview(labelForSecondCollectionView)
        labelForSecondCollectionView.anchor(top:circularCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15 ,paddingLeft: 15)

        contentView.addSubview(carouselCollectionView)
        carouselCollectionView.setHeight(200)
        carouselCollectionView.anchor(top: labelForSecondCollectionView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, right: contentView.rightAnchor ,paddingTop: 10)

    }

    func sampleTest(){
        guard let signIn = GIDSignIn.sharedInstance() else {return}
        signIn.currentUser.authentication.getTokensWithHandler { (auth, error) in
            guard error == nil else { return }
            let accessToken = auth?.accessToken
            let refreshToken = auth?.refreshToken
            print("access: \(accessToken)")
            print("refresh: \(refreshToken)")
        }
    }

}

// MARK: - CollectionView Extensions

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.circularCollectionView {
            return 10
        }else if collectionView == self.carouselCollectionView {
            return 5
        }else {
            return bannerImages.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // first collectionview
        if collectionView == self.circularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: circularIdentifier, for: indexPath as IndexPath) as! ChannelCell
            return cell
        }
        else if collectionView == self.carouselCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselIdentifier, for: indexPath) as! CarouselChannelCell
            cell.backgroundColor = UIColor.blue
            cell.setupShadow()
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerIdentifier, for: indexPath) as! BannerCell
            cell.image = bannerImages[indexPath.row]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sampleTest()
        let controller = ChannelDetailController()
        navigationController?.pushViewController(controller, animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView == carouselCollectionView{
            guard let layout = self.carouselCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
            } else {
                index = Int(round(estimatedIndex))
            }

            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
        }else if scrollView == bannerCollectionView {
            let page = Int(targetContentOffset.pointee.x / view.frame.width)
            self.pageControl.currentPage = page
            counter = page
        }
    }
}
