//
//  ChannelDetailController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/27.
//

import UIKit
import Parchment

let imageSize: CGFloat = 100.adjusted(by: .vertical)

protocol VideoDelegate: AnyObject {
    func openYoutubeVideo(index: Int)
}

class ChannelDetailController: UIViewController {

    // MARK: - Properties

    weak var delegate: VideoDelegate?

    var channel: Channel? {
        didSet {
            configureChannelInfo()
            let detailVC = viewControllers[0] as! DetailViewController
            detailVC.channel = channel
            let videoVC = viewControllers[1] as! VideoViewController
            videoVC.channel = channel
        }
    }

    let headerHeight: CGFloat = 310.adjusted(by: .horizontal)
    let bannerImageHeight: CGFloat = 225.adjusted(by: .horizontal)

    var minHeight: CGFloat {
        var height: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            height = window.safeAreaInsets.top
        }
        return (self.navigationController?.navigationBar.frame.height ?? 0) + height
    }

    private let titles = [
        "상세정보",
        "최신영상"
    ]

    var headerHeightConstraint: NSLayoutConstraint?
    var bannerHeightConstraint: NSLayoutConstraint?

    private var pagingViewController = PagingViewController()

    private let viewControllers = [
        DetailViewController(),
        VideoViewController()
    ]

    private lazy var bannerImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private lazy var thumbnailImageView: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 15.adjusted(by: .horizontal), imageSize: imageSize)
        return cpv
    }()

    private let subscriberCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16.adjusted(by: .horizontal))
        return label
    }()

    private lazy var youtubeLinkButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "play.rectangle.fill"), for: .normal)
        bt.tintColor = .systemRed
        bt.addTarget(self, action: #selector(youtubeAction), for: .touchUpInside)
        return bt
    }()

    private lazy var heartImageButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.tintColor = .systemRed
        bt.addTarget(self, action: #selector(preferAction), for: .touchUpInside)
        return bt
    }()

    private lazy var container = UIView()

    // MARK: - LifeCycle

    init(channelId: Int) {
        super.init(nibName: nil, bundle: nil)
        Service.fetchChannelDetail(channelIdx: channelId) { channel in
            self.channel = channel
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
        configurePaging()
        configureNavBar()
        delegate = viewControllers[1] as! VideoViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavBar()
    }

    // MARK: - API

    func configureChannelInfo() {
        guard let channel = channel else {
            return
        }
        thumbnailImageView.setImage(url: channel.thumbnailUrl)
        thumbnailImageView.title = channel.title
        bannerImage.sd_setImage(with: channel.bannerImageUrl)
        subscriberCount.text = channel.subscriberCountText
        heartImageButton.setImage(channel.isPreffered ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)

    }

    // MARK: - Helpers

    private func configurePaging() {
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        viewControllers.first?.tableView.delegate = self
        pagingViewController.indicatorOptions = .visible(height: 3, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4 ))
        pagingViewController.indicatorColor = .mainColor_3
        pagingViewController.selectedTextColor = .mainColor_5

        pagingViewController.view.anchor(top: container.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

    }

    private func configureUI() {
        view.addSubview(container)

        container.clipsToBounds = true
        container.addSubview(bannerImage)

        bannerImage.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor)
        bannerHeightConstraint = bannerImage.heightAnchor.constraint(equalToConstant: bannerImageHeight)
        bannerHeightConstraint?.isActive = true

        let overlay: UIView = UIView()
        let color = UIColor.black.withAlphaComponent(0.4)
        overlay.backgroundColor = color
        bannerImage.addSubview(overlay)
        overlay.fillSuperview()

        container.addSubview(thumbnailImageView)
        thumbnailImageView.centerX(inView: container)
        thumbnailImageView.anchor(top: bannerImage.bottomAnchor, paddingTop: -imageSize/2)
        container.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)

        headerHeightConstraint = container.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint?.isActive = true

        container.addSubview(subscriberCount)
        subscriberCount.anchor(left: container.leftAnchor, bottom: container.bottomAnchor, paddingLeft: 15, paddingBottom: 50)
        subscriberCount.layer.zPosition = -1

        container.addSubview(youtubeLinkButton)
        youtubeLinkButton.anchor(bottom: container.bottomAnchor, right: container.rightAnchor, paddingBottom: 50, paddingRight: 15)
        youtubeLinkButton.layer.zPosition = -1

        container.addSubview(heartImageButton)
        heartImageButton.anchor(bottom: container.bottomAnchor, right: youtubeLinkButton.leftAnchor, paddingBottom: 50, paddingRight: 5)
        heartImageButton.layer.zPosition = -1
    }

    // transparent navigation bar
    // 블로그 기록
    private func configureNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.adjusted(by: .horizontal), weight: .semibold)]
        self.navigationItem.title = " "
    }

    private func resetNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .mainColor_5
    }

    // MARK: - Actions
    @objc func youtubeAction() {
        guard let channel = channel else {
            return
        }
        let appURL = NSURL(string: "youtube://www.youtube.com/channel/" + channel.channelId!)!
        let webURL = NSURL(string: "https://www.youtube.com/channel/" + channel.channelId!)!
        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }

    @objc func preferAction() {
        guard let channel = channel else { return }
        guard let user = UserInfo.user else { return }
        heartImageButton.isUserInteractionEnabled = false
        if channel.isPreffered {
            Service.deletePreferredChannel(userId: user.id, channelIdx: channel.channelIdx!) { response in
                switch response {
                case .success(_):
                    self.heartImageButton.setImage(UIImage(systemName: "heart"), for: .normal)
                case .failure(_):
                    break
                }
                self.heartImageButton.isUserInteractionEnabled = true
            }
        } else {
            Service.updatePreferredChannel(userId: user.id, channelIdx: channel.channelIdx!) { response in
                switch response {
                case .success(_):
                    self.heartImageButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                case .failure(_):
                    break
                }
                self.heartImageButton.isUserInteractionEnabled = true
            }
        }

    }

}

extension ChannelDetailController: PagingViewControllerDataSource {
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let viewController = viewControllers[index]
        viewController.title = titles[index]
//        let height = pagingViewController.options.menuHeight + ChannelDetailPagingView.HeaderHeight
//        let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
//        viewController.tableView.contentInset = insets
//        viewController.tableView.scrollIndicatorInsets = insets
      //  viewController.tableView.bounces = false
        return viewController
    }

    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return viewControllers.count
    }
}

extension ChannelDetailController: PagingViewControllerDelegate {
    func pagingViewController(_: PagingViewController, didScrollToItem _: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        guard let startingViewController = startingViewController as? UITableViewController else { return }
        guard let destinationViewController = destinationViewController as? UITableViewController else { return }

        // Set the delegate on the currently selected view so that we can
        // listen to the scroll view delegate.
        if transitionSuccessful {
            startingViewController.tableView.delegate = nil
            destinationViewController.tableView.delegate = self
        }
    }
}

extension ChannelDetailController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.openYoutubeVideo(index: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  print(scrollView.contentOffset.y)
     //   let changeStartOffset: CGFloat = -100.adjusted(by: .vertical)
        let changeSpeed: CGFloat = 50.adjusted(by: .vertical)
        thumbnailImageView.alpha = min(1.0, (bannerHeightConstraint!.constant - minHeight) / changeSpeed)
        // print(bannerHeightConstraint!.constant, headerHeightConstraint!.constant)
        if headerHeightConstraint!.constant == minHeight {
            self.navigationItem.title = channel?.title
        } else {
            self.navigationItem.title = " "
        }
        guard scrollView.contentOffset.y > 0 else {
            if headerHeightConstraint!.constant < headerHeight {
                headerHeightConstraint!.constant += min(abs(scrollView.contentOffset.y) * 3, 10)
                if bannerHeightConstraint!.constant < bannerImageHeight {
                    bannerHeightConstraint!.constant += min(abs(scrollView.contentOffset.y) * 3, 10)
                }

                scrollView.contentOffset.y = 0
            }
            if headerHeightConstraint!.constant > headerHeight {
                headerHeightConstraint!.constant = headerHeight
            }
            if bannerHeightConstraint!.constant > bannerImageHeight {
                bannerHeightConstraint!.constant = bannerImageHeight
            }
            return
        }
        // print("DEBUG: height: \( headerHeightConstraint!.constant) ,minHeight:\(minHeight)")
        if headerHeightConstraint!.constant > minHeight {
            headerHeightConstraint!.constant = max(headerHeightConstraint!.constant - scrollView.contentOffset.y, minHeight )
            bannerHeightConstraint!.constant = max(bannerHeightConstraint!.constant - scrollView.contentOffset.y, minHeight )
            scrollView.contentOffset.y = 0
        }
    }

}
