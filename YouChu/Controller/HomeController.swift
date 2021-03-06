//
//  HomeController.swift
//  YouChu
//
//  Created by κΉνμ on 2021/04/15.
//

import UIKit
import GoogleSignIn
import SDWebImage

let bannerIdentifier = "banner"
let circularIdentifier = "circular"
let carouselIdentifier = "carousel"

class HomeController: UIViewController {

    // MARK: - Properties
    var timer = Timer()
    var counter = 0
    var previousIndex = 0

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = banners.count
        pc.currentPage = 0
        return pc
    }()

    private var banners: [Banner] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 244.adjusted(by: .vertical))
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
        let cellWidth = 285.adjusted(by: .horizontal)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        layout.itemSize = CGSize(width: cellWidth, height: 165.adjusted(by: .vertical))
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.adjusted(by: .horizontal)
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
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

    private let labelForFirstCollectionView: UILabel = {
        let label = UILabel()
        label.attributedText = "λΉμ λ§μ μν λ§μΆ€ μ±λ".localized().coloredAttributedColor( stringToColor: "λ§μΆ€".localized(), color: .complementaryColor2)
        label.font = UIFont.boldSystemFont(ofSize: 18.adjusted(by: .horizontal))
        return label
    }()

    private lazy var moreButtonForFirst: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("λ λ³΄κΈ°".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        return button
    }()

    private let labelForSecondCollectionView: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.adjusted(by: .horizontal))
        return label
    }()

    private lazy var moreButtonForSecond: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("λ λ³΄κΈ°".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        return button
    }()

    private var recommendedChannels: [Channel] = []
    private var relatedChannel: [Channel] = []
    private var recommendedChannelsMax: [Channel] = []
    private var relatedChannelMax: [Channel] = []

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchBanners()
        setNotification()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "titleLogo"))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill")?.withTintColor(.mainColor_4), style: .plain, target: self, action: #selector(handleNotification))
        fetchUser()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - API

    func fetchBanners() {

        if !NetMonitor.shared.internetConnection {
            if let channelsJson = UserDefaults.standard.object(forKey: "banner") as? Data {
                let decoder = JSONDecoder()
                if let banners = try? decoder.decode([Banner].self, from: channelsJson) {
                    self.banners = banners
                }
            }
        } else {

            Service.fetchBanners { [self] result in
                switch result {
                case .success(let banners):
                    self.banners = banners
                    do {
                        let encoder = JSONEncoder()
                        let encoded = try encoder.encode(banners)
                        UserDefaults.standard.set(encoded, forKey: "banner")
                    } catch let error {
                        print(error)
                    }
                    bannerCollectionView.reloadData()
                case .failure(let err):
                    self.showMessage(withTitle: "Err", message: "Failed to fetch banners \(err)")
                }
            }
        }
    }

    func fetchUser() {
        if UserInfo.user != nil || !NetMonitor.shared.internetConnection {
            self.fetchRelatedChannels()
            self.fetchRecommendedChannels()
        } else {
            let tk = TokenUtils()
            guard let userId = tk.getUserIdFromToken(TokenUtils.service) else {
                return
            }
            showLoader(true)
            UserInfo.fetchUser(userId: userId) { result in
                switch result {
                case .success(let data):
                    self.fetchRecommendedChannels()
                    self.fetchRelatedChannels()
                    do {
                        let encoder = JSONEncoder()
                        let encoded = try encoder.encode(data)
                        UserDefaults.standard.set(encoded, forKey: "user")
                    } catch let error {
                        print(error)
                    }
                    self.showLoader(false)
                case .failure(let err):
                    self.showMessage(withTitle: "Error", message: "Unable to fetch user \(err)")
                    self.showLoader(false)
                }
            }
        }
    }

    func fetchRecommendedChannels() {
        if !NetMonitor.shared.internetConnection {
            if let channelsJson = UserDefaults.standard.object(forKey: "recommend") as? Data {
                let decoder = JSONDecoder()
                if let channels = try? decoder.decode([Channel].self, from: channelsJson) {
                    recommendedChannels = Array(channels.prefix(upTo: 12))
                    recommendedChannelsMax = channels
                }
            }
        }
        guard let user = UserInfo.user else {
            return
        }
        // first recommended list
        Service.fetchRecommendChannelList(userId: user.id, size: 10, page: 0) { result in
            switch result {
            case .success(let data):
                self.recommendedChannels = Array(data.prefix(upTo: 12))
                self.recommendedChannelsMax = data
                /// DataManager.sharedInstance.saveChannels(data)\
                do {
                    let encoder = JSONEncoder()
                    let encoded = try encoder.encode(data)
                    UserDefaults.standard.set(encoded, forKey: "recommend")
                } catch let error {
                    print(error)
                }

                self.circularCollectionView.reloadData()
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "Unable to fetch data from server")
            }
        }
    }

    func setNotification() {
        let manager = LocalNotificationManager()
        manager.requestPermission()
        manager.addNotification(title: "μ μ¬ λ¨Ήκ³  λλ₯Έν μ§κΈ μ μΆμμ μλ‘μ΄ μ±λμ μ°Ύμλ³΄μΈμ!")
        manager.scheduleNotifications()
    }

    func fetchRelatedChannels() {

        if !NetMonitor.shared.internetConnection {
            if let channelsJson = UserDefaults.standard.object(forKey: "related") as? Data {
                let decoder = JSONDecoder()
                if let channels = try? decoder.decode([Channel].self, from: channelsJson) {
                    relatedChannel = Array(channels.prefix(upTo: 12))
                    relatedChannelMax = channels
                }
            }
        }

        guard let user = UserInfo.user else {
            return
        }
        // first recommended list
        Service.fetchRelatedChannels(userId: user.id, size: 10, page: 0) { result, standardValue in
            switch result {
            case .success(let data):
                var channelName = standardValue
                if channelName.count > 19 {
                    let endIdx = channelName.index(channelName.startIndex, offsetBy: 17)
                    channelName = channelName[channelName.startIndex..<endIdx] + "..."
                }
                self.labelForSecondCollectionView.attributedText = (channelName + "μ μ°κ΄λ μ±λ".localized()).coloredAttributedColor(stringToColor: "μ°κ΄λ".localized(), color: .complementaryColor)
                self.relatedChannel = Array(data.prefix(upTo: 12))
                self.relatedChannelMax = data
                do {
                    let encoder = JSONEncoder()
                    let encoded = try encoder.encode(data)
                    UserDefaults.standard.set(encoded, forKey: "related")
                } catch let error {
                    print(error)
                }
                self.carouselCollectionView.reloadData()
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "Unable to fetch data from server")
            }
        }
    }

    // MARK: - Actions
    @objc func changeImage() {
        if counter < banners.count {
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

    @objc func handleMore(_ sender: UIButton) {
        if sender == moreButtonForFirst {
            let title = "λ§μΆ€ μ±λ".localized().coloredAttributedColor(stringToColor: "λ§μΆ€".localized(), color: .complementaryColor2)
            let controller = ChannelListNEViewController(title: title, channels: recommendedChannelsMax, type: .recommended)
            self.navigationController?.pushViewController(controller, animated: true)
        } else if sender == moreButtonForSecond {
            let title = "μ°κ΄ μ±λ".localized().coloredAttributedColor(stringToColor: "μ°κ΄".localized(), color: .complementaryColor)
            let controller = ChannelListNEViewController(title: title, channels: relatedChannelMax, type: .related)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc func handleNotification() {
        print("hello")
    }

    // MARK: - Helpers

    func configureUI() {

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.centerX(inView: view)

        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.centerX(inView: scrollView)

        contentView.addSubview(bannerCollectionView)
        bannerCollectionView.setHeight(250)
        bannerCollectionView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)

        contentView.addSubview(pageControl)
        pageControl.anchor( bottom: bannerCollectionView.bottomAnchor, right: contentView.rightAnchor, paddingBottom: 16, paddingRight: 55 )

        contentView.addSubview(labelForFirstCollectionView)
        labelForFirstCollectionView.anchor(top: bannerCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 38, paddingLeft: 17)

        contentView.addSubview(moreButtonForFirst)
        moreButtonForFirst.centerY(inView: labelForFirstCollectionView)
        moreButtonForFirst.anchor(right: contentView.rightAnchor, paddingRight: 17)

        contentView.addSubview(circularCollectionView)
        circularCollectionView.setHeight(110)
        circularCollectionView.anchor(top: labelForFirstCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20)

        contentView.addSubview(labelForSecondCollectionView)
        labelForSecondCollectionView.anchor(top: circularCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 38, paddingLeft: 17, paddingBottom: 18)

        contentView.addSubview(moreButtonForSecond)
        moreButtonForSecond.centerY(inView: labelForSecondCollectionView)
        moreButtonForSecond.anchor(right: contentView.rightAnchor, paddingRight: 17)

        contentView.addSubview(carouselCollectionView)
        carouselCollectionView.setHeight(165)
        carouselCollectionView.anchor(top: labelForSecondCollectionView.bottomAnchor, left: contentView.leftAnchor,
                                      bottom: contentView.safeAreaLayoutGuide.bottomAnchor, right: contentView.rightAnchor, paddingTop: 20)

    }

    func animateClearCell(_ cell: UICollectionViewCell) {
        UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { cell.alpha = 1.0 }, completion: nil)
    }
    func animateDimCell(_ cell: UICollectionViewCell) {
        UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { cell.alpha = 0.5 }, completion: nil)
    }
}

// MARK: - CollectionView Extensions

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.circularCollectionView {
            return recommendedChannels.count
        } else if collectionView == self.carouselCollectionView {
            return relatedChannel.count
        } else {
            return banners.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // first collectionview
        if collectionView == self.circularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: circularIdentifier, for: indexPath as IndexPath) as! CircularChannelCell
            cell.channel = recommendedChannels[indexPath.row]
            return cell
        } else if collectionView == self.carouselCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselIdentifier, for: indexPath) as! CarouselChannelCell
            cell.channel = relatedChannel[indexPath.row]
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.alpha = 0.5
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerIdentifier, for: indexPath) as! BannerCell
            cell.bannerImage.sd_setImage(with: URL(string: banners[indexPath.row].bannerUrl))
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.circularCollectionView {
            let controller = ChannelDetailController(channelId: recommendedChannels[indexPath.row].channelIdx!)
            navigationController?.pushViewController(controller, animated: true)
        } else if collectionView == self.carouselCollectionView {
            let controller = ChannelDetailController(channelId: relatedChannel[indexPath.row].channelIdx!)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            if let url = URL(string: banners[indexPath.row].connectUrl) {
                UIApplication.shared.open(url)
            }

        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView == carouselCollectionView {
            let cellWidthIncludeSpacing = 285.adjusted(by: .horizontal) + 20
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
            let roundedIndex: CGFloat = round(index)
            offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        } else if scrollView == bannerCollectionView {
            let page = Int(targetContentOffset.pointee.x / view.frame.width)
            self.pageControl.currentPage = page
            counter = page
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == carouselCollectionView {
            let cellWidthIncludeSpacing = 285.adjusted(by: .horizontal) + 20
            let offsetX = carouselCollectionView.contentOffset.x
            let index = (offsetX + carouselCollectionView.contentInset.left) / cellWidthIncludeSpacing
            let roundedIndex = round(index)
            let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
            if let cell = carouselCollectionView.cellForItem(at: indexPath) { animateClearCell(cell)
            }
            if Int(roundedIndex) != previousIndex {
                let preIndexPath = IndexPath(item: previousIndex, section: 0)
                if let preCell = carouselCollectionView.cellForItem(at: preIndexPath) { animateDimCell(preCell)
                }
                previousIndex = indexPath.item
            }
        }
    }
}
