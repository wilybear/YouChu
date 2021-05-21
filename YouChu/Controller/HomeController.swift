//
//  HomeController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit

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
        layout.itemSize = CGSize(width: view.frame.width , height: 244.adjusted(by: .vertical))
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
        layout.itemSize = CGSize(width: view.frame.width - 80.adjusted(by: .horizontal), height: 200.adjusted(by: .vertical))
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.adjusted(by: .horizontal)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20.adjusted(by: .horizontal), bottom: 0, right: 20.adjusted(by: .horizontal))
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
        layout.minimumInteritemSpacing = 20.adjusted(by: .horizontal)
        layout.minimumLineSpacing = 20.adjusted(by: .horizontal)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20.adjusted(by: .horizontal), bottom: 5, right: 20.adjusted(by: .horizontal))
        layout.itemSize = CGSize(width: (view.frame.width - 5)/itemsPerRow, height: 100.adjusted(by: .vertical))
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
        cv.register(CircularChannelCell.self, forCellWithReuseIdentifier: circularIdentifier)

        return cv
    }()


    // TODO: custom view로 만들기
    private let labelForFirstCollectionView: UILabel = {
        let label = UILabel()
        label.text = "당신만을 위한 추천 채널"
        label.font = UIFont.boldSystemFont(ofSize: 20.adjusted(by: .horizontal))
        return label
    }()

    private let labelForSecondCollectionView: UILabel = {
        let label = UILabel()
        label.text = "00과 비슷한 채널"
        label.font = UIFont.boldSystemFont(ofSize: 20.adjusted(by: .horizontal))
        return label
    }()

    private var recommendedChannels:[Channel] = []
    private var topicChannels:[Channel] = []


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchRecommendedChannels()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "titleLogo"))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: - API
    func fetchRecommendedChannels(){
        guard let user = UserInfo.user else {
            return
        }
        // first recommended list
        Service.fetchRecommendChannelList(userId: user.id, size: 10, page: 0) { result in
            switch result{
            case .success(let data):
                guard let channels = data.data else {
                    return
                }
                self.recommendedChannels.append(contentsOf: channels)
                self.circularCollectionView.reloadData()
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "Unable to fetch data from server")
            }
        }
    }

    func fetchTopicRelatedChannels(){
        guard let user = UserInfo.user else {
            return
        }
        // first recommended list
        Service.fetchRandomTopicChannelList(userId: user.id, size: 10, page: 0) { result in
            switch result{
            case .success(let data):
                guard let channels = data.data else {
                    return
                }
                self.topicChannels.append(contentsOf: channels)
                self.carouselCollectionView.reloadData()
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "Unable to fetch data from server")
            }
        }
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
        pageControl.anchor( bottom: bannerCollectionView.bottomAnchor, right: contentView.rightAnchor, paddingBottom: 16, paddingRight: 55 )

        contentView.addSubview(labelForFirstCollectionView)

        labelForFirstCollectionView.anchor(top:bannerCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 48, paddingLeft: 17)

        contentView.addSubview(circularCollectionView)
        circularCollectionView.setHeight(100)
        circularCollectionView.anchor(top: labelForFirstCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20)

        contentView.addSubview(labelForSecondCollectionView)
        labelForSecondCollectionView.anchor(top:circularCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 48 ,paddingLeft: 17)

        contentView.addSubview(carouselCollectionView)
        carouselCollectionView.setHeight(165)
        carouselCollectionView.anchor(top: labelForSecondCollectionView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, right: contentView.rightAnchor)

    }


}

// MARK: - CollectionView Extensions

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.circularCollectionView {
            return recommendedChannels.count
        }else if collectionView == self.carouselCollectionView {
            return topicChannels.count
        }else {
            return bannerImages.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // first collectionview
        if collectionView == self.circularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: circularIdentifier, for: indexPath as IndexPath) as! CircularChannelCell
            cell.channel = recommendedChannels[indexPath.row]
            return cell
        }
        else if collectionView == self.carouselCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselIdentifier, for: indexPath) as! CarouselChannelCell
            cell.channel = topicChannels[indexPath.row]
            cell.setupShadow()
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerIdentifier, for: indexPath) as! BannerCell
            cell.image = bannerImages[indexPath.row]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.circularCollectionView {
            let controller = ChannelDetailController(channelId: recommendedChannels[indexPath.row].channelIdx!)
            navigationController?.pushViewController(controller, animated: true)
        }else if collectionView == self.carouselCollectionView {
            let controller = ChannelDetailController(channelId: topicChannels[indexPath.row].channelIdx!)
            navigationController?.pushViewController(controller, animated: true)
        }else{

        }
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
