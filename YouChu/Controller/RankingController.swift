//
//  RankingController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//


import UIKit

let rankCellIdentifier = "rankCell"

class RankingController: UIViewController {

    var channels:[Channel] = []
    var currentPage = 0
    var isLastPage = false
    var isPaging = false

    var currentTopic: Topic = .all

    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 90.adjusted(by: .vertical)
        tv.delegate = self
        tv.dataSource = self
        tv.register(RankingTableViewCell.self, forCellReuseIdentifier: rankCellIdentifier)
        return tv
    }()

    private let header: RankingHeader = {
        let header = RankingHeader(frame: CGRect.zero)
        return header
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showLoader(true)
        fetchRankingChannel(with: .all, pageNumber: currentPage)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - API
    func fetchRankingChannel(with topic:Topic, pageNumber: Int) {
        showLoader(true)
        isPaging = true
        Service.fetchRankingChannelList(of: topic,userId: (UserInfo.user?.id)! ,size: 20, page: pageNumber) { result in
            switch result {
            case .success(let page):
                if page.last{
                    self.isLastPage = true
                    self.isPaging = false
                    self.showLoader(false)
                    break
                }
                self.channels.append(contentsOf: page.data ?? [])
                self.tableView.reloadData()
                self.currentPage += 1

                self.isPaging = false

                //when first intialize, scroll to the top
                if self.currentPage == 1 {
                    self.scrollToTop()
                }
                self.showLoader(false)
            case .failure(let err):
                self.showMessage(withTitle: "Err", message: "Cannot fetch list from server: \(err)")
                self.isPaging = false
                self.showLoader(false)
            }
        }
    }

    // MARK: - Helpers

    private func configureUI(){
        view.addSubview(header)
        header.delegate = self
        header.setHeight(105)
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        view.addSubview(tableView)
        tableView.anchor(top: header.bottomAnchor, left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }

    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)

        self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
}

// MARK: - UITableViewDelegate, DataSource

extension RankingController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rankCellIdentifier, for: indexPath) as! RankingTableViewCell
        cell.rank = indexPath.row + 1
        cell.channel = channels[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChannelDetailController(channelId: channels[indexPath.row].channelIdx!)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: DumiData

extension RankingController: RankingHeaderDelegate {
    func sendCategoryIndex(topic: Topic) {
        channels = []
        currentPage = 0
        isLastPage = false
        currentTopic = topic
        fetchRankingChannel(with: topic, pageNumber: currentPage)

    }
}

extension RankingController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        if offsetY > (contentHeight - height) {
            if isPaging == false && !isLastPage {
                fetchRankingChannel(with: currentTopic, pageNumber: currentPage)
            }
        }
    }
}
