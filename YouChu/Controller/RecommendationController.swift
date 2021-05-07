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
        return view
    }()

    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 채널은 어떠세요?"
        label.font = UIFont.boldSystemFont(ofSize: 22.adjusted(by: .horizontal))
        label.textAlignment = .center
        return label
    }()

    private let likeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .systemPink
        button.addTarget(self, action: #selector(handleLikeAction), for: .touchUpInside)
        return button
    }()

    private let dislikeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_close").withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .systemGray
        button.addTarget(self, action: #selector(handleDislikeAction), for: .touchUpInside)
        return button
    }()

    private var recommendingChannel: Channel? {
        didSet{
            guard let channel = recommendingChannel else {
                return
            }
            channelCardView.channel = channel
        }
    }


    // MARK: - LifeCycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        recommendingChannel = Test.fetchData().randomElement()!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        channelCardView.channel = recommendingChannel!
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lockButton(true)
        _ = channelCardView.slideIn(from:.top) { _ in
            self.lockButton(false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }


    // MARK: - Helpers

    func configureUI(){
        view.addSubview(helpLabel)
        helpLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30)

        let stack = UIStackView(arrangedSubviews: [dislikeButton, likeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.setDimensions(height: 60, width: 140, by: .vertical)
        stack.setCustomSpacing(20.adjusted(by: .vertical), after: dislikeButton)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)

        view.addSubview(channelCardView)
        channelCardView.anchor(top:helpLabel.bottomAnchor, left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor ,paddingTop: 20, paddingLeft: 50, paddingBottom: 20, paddingRight: 50)
        channelCardView.alpha = 0.2
    }


    func lockButton(_ isAnimating:Bool){
        likeButton.isUserInteractionEnabled = !isAnimating
        dislikeButton.isUserInteractionEnabled = !isAnimating
    }

    // MARK: - Actions

    @objc func handleLikeAction(){
        lockButton(true)
        _ = self.channelCardView.slideOut(from: .right) { finished in
            self.recommendingChannel = Test.fetchData().randomElement()!
            _ = self.channelCardView.slideIn(from: .top)
            self.lockButton(false)
        }
    }

    @objc func handleDislikeAction(){
        _ = self.channelCardView.slideOut(from: .left) { finished in
            self.recommendingChannel = Test.fetchData().randomElement()!
            _ = self.channelCardView.slideIn(from: .top)
            self.lockButton(false)
        }
    }
}

// MARK: DumiData

extension RecommendationController: ChannelCardViewDelegate {
    func handleDetailButton(_ channelCardView: ChannelCardView) {
        let controller = ChannelDetailController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension RecommendationController {
    func fetchData() -> [String]{
        return ["승우 아빠", "Black Pink - Official channel"]
    }
}
