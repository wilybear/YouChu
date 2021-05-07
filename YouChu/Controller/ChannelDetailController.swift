//
//  Test2.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/29.
//

//
//  ChannelDetailController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/27.
//

import UIKit
import Parchment

let imageSize: CGFloat = 100.adjusted(by: .vertical)

class ChannelDetailController: UIViewController{

    // MARK: - Properties

    let headerHeight: CGFloat = 310.adjusted(by: .horizontal)
    let bannerImageHeight: CGFloat = 225.adjusted(by: .horizontal)

    var minHeight: CGFloat {
        var height: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            height = window.safeAreaInsets.top
        }else if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            height = (window?.safeAreaInsets.top)!
        }
        return (self.navigationController?.navigationBar.frame.height ?? 0) + height
    }

    private let titles = [
        "상세정보",
        "인기영상"
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
        iv.image =  #imageLiteral(resourceName: "dingo_banner")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private lazy var thumbnailImageView: CircularProfileView = {
        let cpv = CircularProfileView(fontSize: 15.adjusted(by: .horizontal), imageSize: imageSize)
        cpv.image = #imageLiteral(resourceName: "dingo")
        cpv.title = "딩고 뮤직 / dingo music"
        return cpv
    }()

    private let subscriberCount: UILabel = {
        let label = UILabel()
        label.text = "구독자 293만명"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14.adjusted(by: .horizontal))
        return label
    }()

    private lazy var youtubeLinkButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "play.rectangle.fill"), for: .normal)
        bt.tintColor = .systemRed
        return bt
    }()

    private lazy var container = UIView()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
        configurePaging()
        configureNavBar()
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

    // MARK: - Helpers

    private func configurePaging(){
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        viewControllers.first?.tableView.delegate = self
        pagingViewController.indicatorOptions = .visible(height: 3, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4 ))
        pagingViewController.indicatorColor = .systemOrange
        pagingViewController.selectedTextColor = .systemOrange

        pagingViewController.view.anchor(top: container.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

    }

    private func configureUI(){
        view.addSubview(container)

        container.clipsToBounds = true
        container.addSubview(bannerImage)

        bannerImage.anchor(top:container.topAnchor, left: container.leftAnchor , right: container.rightAnchor)
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
        container.anchor(top:view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)

        headerHeightConstraint = container.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint?.isActive = true

        container.addSubview(subscriberCount)
        subscriberCount.anchor(left: container.leftAnchor, bottom: container.bottomAnchor,paddingLeft: 15, paddingBottom: 50)
        subscriberCount.layer.zPosition = -1

        container.addSubview(youtubeLinkButton)
        youtubeLinkButton.anchor(bottom: container.bottomAnchor, right: container.rightAnchor, paddingBottom: 50, paddingRight: 15)
        youtubeLinkButton.layer.zPosition = -1
    }

    // transparent navigation bar
    // 블로그 기록
    private func configureNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.adjusted(by: .horizontal), weight: .semibold)]
        self.navigationItem.title = " "
    }

    private func resetNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.adjusted(by: .horizontal), weight: .semibold)]
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

//    func pagingViewController(_: PagingViewController, willScrollToItem _: PagingItem, startingViewController _: UIViewController, destinationViewController: UIViewController) {
//        guard let destinationViewController = destinationViewController as? UITableViewController else { return }
//
//        // Update the content offset based on the height of the header
//        // view. This ensures that the content offset is correct if you
//        // swipe to a new page while the header view is hidden.
//        if let scrollView = destinationViewController.tableView {
//            let offset = headerConstraint.constant + pagingViewController.options.menuHeight
//            scrollView.contentOffset = CGPoint(x: 0, y: -offset + 10)
//            updateScrollIndicatorInsets(in: scrollView)
//        }
//    }
}

extension ChannelDetailController: UITableViewDelegate{
//    func updateScrollIndicatorInsets(in scrollView: UIScrollView) {
//        let offset = min(0, scrollView.contentOffset.y) * -1
//        let insetTop = max(pagingViewController.options.menuHeight, offset)
//        let insets = UIEdgeInsets(top: insetTop, left: 0, bottom: 0, right: 0)
//        scrollView.scrollIndicatorInsets = insets
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

      //  print(scrollView.contentOffset.y)
        let changeStartOffset: CGFloat = -100.adjusted(by: .vertical)
        let changeSpeed: CGFloat = 50.adjusted(by: .vertical)
        thumbnailImageView.alpha = min(1.0, (bannerHeightConstraint!.constant - minHeight) / changeSpeed)
        //print(bannerHeightConstraint!.constant, headerHeightConstraint!.constant)
        if headerHeightConstraint!.constant == minHeight {
            self.navigationItem.title = "딩고 뮤직 / dingo music"
        }else{
            self.navigationItem.title = " "
        }
        guard scrollView.contentOffset.y > 0 else {
            if headerHeightConstraint!.constant < headerHeight {
                headerHeightConstraint!.constant += min(abs(scrollView.contentOffset.y) * 3,10)
                if bannerHeightConstraint!.constant < bannerImageHeight {
                    bannerHeightConstraint!.constant += min(abs(scrollView.contentOffset.y) * 3,10)
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
        //print("DEBUG: height: \( headerHeightConstraint!.constant) ,minHeight:\(minHeight)")
        if headerHeightConstraint!.constant > minHeight {
            headerHeightConstraint!.constant = max(headerHeightConstraint!.constant - scrollView.contentOffset.y, minHeight )
            bannerHeightConstraint!.constant = max(bannerHeightConstraint!.constant - scrollView.contentOffset.y, minHeight )
            scrollView.contentOffset.y = 0
        }



//        let percentage = (offset-100)/50
//        container.alpha = percentage

        // Update the scroll indicator insets so they move alongside the
        // header view when scrolling.
//        updateScrollIndicatorInsets(in: scrollView)

        // Update the height of the header view based on the content
        // offset of the currently selected view controller.
//        let height = max(0, abs(scrollView.contentOffset.y) - pagingViewController.options.menuHeight)
//        headerConstraint.constant = height
    }
}





