//
//  RecommendationController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit

class RecommendationController: UIViewController {

    // MARK: - Properties

    private lazy var channelCardView: ChannelCardView = {
        let view = ChannelCardView()
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardViewPanGesture)))
        return view
    }()

    private let helpLabel: UILabel = {
        let label = UILabel()
        label.attributedText = "이런 채널은 어떠세요?".localized().coloredAttributedColor(stringToColor: "채널".localized(), color: .complementaryColor)
        label.font = UIFont.boldSystemFont(ofSize: 22.adjusted(by: .horizontal))
        label.textAlignment = .center
        return label
    }()

    private let likeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup.fill")!.withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .mainColor_4
        button.addTarget(self, action: #selector(handleLikeAction), for: .touchUpInside)
        return button
    }()

    private let dislikeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsdown.fill")!.withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .complementaryColor2
        button.addTarget(self, action: #selector(handleDislikeAction), for: .touchUpInside)
        return button
    }()

    private let refreshButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .lightGray
        button.addTarget(self, action: #selector(handleRefreshAction), for: .touchUpInside)
        return button
    }()

    private var recommendingChannel: Channel? {
        didSet {
            guard let channel = recommendingChannel else {
                return
            }
            channelCardView.channel = channel
        }
    }

    // MARK: - LifeCycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        recommendingChannel = Test.fetchData().randomElement()!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRandomChannel(completion: nil)
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    func fetchRandomChannel(completion: ((Channel) -> Void)?) {
        guard let user = UserInfo.user else { return }
        Service.fetchRandomChannel(userId: user.id) { result in
            switch result {
            case .success(let channel):
                self.recommendingChannel = channel
                completion?(channel)
            case .failure(let err):
                self.showMessage(withTitle: "Error", message: "Cannot fetch random channel \(err)")
            }
        }
    }

    // MARK: - Helpers

    func configureUI() {
        view.addSubview(helpLabel)
        helpLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30)

        let stack = UIStackView(arrangedSubviews: [dislikeButton, refreshButton, likeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.setDimensions(height: 55, width: 205, by: .vertical)
        stack.setCustomSpacing(20.adjusted(by: .vertical), after: dislikeButton)
        stack.setCustomSpacing(20.adjusted(by: .vertical), after: refreshButton)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)

        view.addSubview(channelCardView)
        channelCardView.anchor(top: helpLabel.bottomAnchor, left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 50, paddingBottom: 20, paddingRight: 50)
        channelCardView.alpha = 0
    }

    func lockButton(_ isAnimating: Bool) {
        likeButton.isUserInteractionEnabled = !isAnimating
        dislikeButton.isUserInteractionEnabled = !isAnimating
    }

    // MARK: - Actions

    @objc func handleLikeAction() {
        lockButton(true)

        Service.updatePreferredChannel(userId: UserInfo.user!.id, channelIdx: (recommendingChannel?.channelIdx)!) { result in
            switch result {
            case .success(_):
         //       let dic = ["channel": self.recommendingChannel!]
         //       NotificationCenter.default.post(name: Notification.Name("preferStateChange"), object: dic)
                break
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "failed to update prefer channel")
            }
        }

        _ = self.channelCardView.slideOut(from: .right) { _ in
            // TODO: fetch random channel
            self.fetchRandomChannel { _ in
                self.lockButton(false)
            }
        }
    }

    @objc func handleRefreshAction() {
        lockButton(true)
        _ = self.channelCardView.slideOut(from: .top) { _ in
            // TODO: fetch random channel
            self.fetchRandomChannel { _ in
                self.lockButton(false)
            }
        }
    }

    @objc func handleDislikeAction() {
        lockButton(true)

        Service.updateDislikedChannel(userId: UserInfo.user!.id, channelIdx: (recommendingChannel?.channelIdx)!) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "failed to update dislike channel")
            }
        }

        _ = self.channelCardView.slideOut(from: .left) { _ in
            self.fetchRandomChannel { _ in
                self.lockButton(false)
            }
        }
    }

    @objc func handleCardViewPanGesture(gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .began:
            break
        case .changed:
            let translatioon = gesture.translation(in: self.view)
            channelCardView.transform = CGAffineTransform(translationX: translatioon.x, y: 0)
        case .ended, .cancelled:
            let translation = gesture.translation(in: view)
            if translation.x > 100.adjusted(by: .horizontal) {
                handleLikeAction()
            } else if translation.x < -100.adjusted(by: .horizontal) {
                handleDislikeAction()
            } else {
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                    self.channelCardView.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
        default:
            break
        }
    }
}

// MARK: DumiData

extension RecommendationController: ChannelCardViewDelegate {
    func slideInAfterLoading() {
        _ = self.channelCardView.slideIn(from: .top)
    }

    func handleDetailButton(_ channelCardView: ChannelCardView) {
        let controller = ChannelDetailController(channelId: (recommendingChannel?.channelIdx)!)
        navigationController?.pushViewController(controller, animated: true)
    }
}
