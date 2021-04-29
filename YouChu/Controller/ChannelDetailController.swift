//
//  ChannelDetailController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/27.
//

import UIKit
import Parchment

let imageSize:CGFloat = 100

class ChannelDetailController: UIViewController{

    // MARK: - Properties

    private var pagingViewController = HeaderPagingViewController()

    private var headerConstraint: NSLayoutConstraint {
        let pagingView = pagingViewController.view as! ChannelDetailPagingView
        print("DEBUG: \(pagingView.headerHeightConstraint!)")
        return pagingView.headerHeightConstraint!
    }

    private let viewControllers = [
        DetailViewController(),
        VideoViewController()
    ]

    private let titles = [
        "상세정보",
        "인기영상"
    ]

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurePaging()
        configureUI()
        configureNavBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    //    bannerImage.addOverlay()
    }

    // MARK: - API

    // MARK: - Helpers

    private func configurePaging(){
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        pagingViewController.indicatorOptions = .visible(height: 3, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4 ))
        pagingViewController.indicatorColor = .systemOrange
        pagingViewController.selectedTextColor = .systemOrange


        pagingViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        
        viewControllers.first?.tableView.delegate = self

    }

    private func configureUI(){

    }

    // transparent navigation bar
    private func configureNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
    }

}

extension ChannelDetailController: PagingViewControllerDataSource {
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let viewController = viewControllers[index]
        viewController.title = titles[index]

        let height = pagingViewController.options.menuHeight + ChannelDetailPagingView.HeaderHeight
        let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        viewController.tableView.contentInset = insets
        viewController.tableView.scrollIndicatorInsets = insets

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

    func pagingViewController(_: PagingViewController, willScrollToItem _: PagingItem, startingViewController _: UIViewController, destinationViewController: UIViewController) {
        guard let destinationViewController = destinationViewController as? UITableViewController else { return }

        // Update the content offset based on the height of the header
        // view. This ensures that the content offset is correct if you
        // swipe to a new page while the header view is hidden.
        if let scrollView = destinationViewController.tableView {
            let offset = headerConstraint.constant + pagingViewController.options.menuHeight
            scrollView.contentOffset = CGPoint(x: 0, y: -offset)
            updateScrollIndicatorInsets(in: scrollView)
        }
    }
}

extension ChannelDetailController: UITableViewDelegate {
    func updateScrollIndicatorInsets(in scrollView: UIScrollView) {
        let offset = min(0, scrollView.contentOffset.y) * -1
        let insetTop = max(pagingViewController.options.menuHeight, offset)
        let insets = UIEdgeInsets(top: insetTop, left: 0, bottom: 0, right: 0)
        scrollView.scrollIndicatorInsets = insets
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y < 0 else {
            // Reset the header constraint in case we scrolled so fast that
            // the height was not set to zero before the content offset
            // became negative.
            if headerConstraint.constant > 0 {
                headerConstraint.constant = 0
            }
            return
        }

        // Update the scroll indicator insets so they move alongside the
        // header view when scrolling.
        updateScrollIndicatorInsets(in: scrollView)

        // Update the height of the header view based on the content
        // offset of the currently selected view controller.
        let height = max(0, abs(scrollView.contentOffset.y) - pagingViewController.options.menuHeight)
        headerConstraint.constant = height
    }
}	




