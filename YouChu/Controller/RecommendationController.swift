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
        label.text = "이런 채널은 어떠세요?"
        label.font = UIFont.boldSystemFont(ofSize: 22.adjusted(by: .horizontal))
        label.textAlignment = .center
        return label
    }()

    private let likeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .mainColor_5
        button.addTarget(self, action: #selector(handleLikeAction), for: .touchUpInside)
        return button
    }()

    private let dislikeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_close").withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .mainColor_1
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
//        recommendingChannel = Test.fetchData().randomElement()!
        //TODO: fetch random channel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRandomChannel(completion: nil)
        configureUI()
        lockButton(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        DispatchQueue.main.async {
            self.lockButton(true)
            _ = self.channelCardView.slideIn(from:.top) { _ in
                self.lockButton(false)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - API

    func fetchRandomChannel(completion: ((Channel)->Void)?){
        guard let user = UserInfo.user else { return }
        Service.fetchRandomChannel(userId: user.id) { result in
            switch result{
            case .success(let channel):
                self.recommendingChannel = channel
                completion?(channel)
            case .failure(let err):
                self.showMessage(withTitle: "Error", message: "Cannot fetch random channel")
            }
        }
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

        Service.updatePreferredChannel(userId: UserInfo.user!.id, channelIdx: (recommendingChannel?.channelIdx)!) { result in
            switch result{
            case .success(_):
                break
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "failed to update prefer channel")
            }
        }

        _ = self.channelCardView.slideOut(from: .right) { finished in
            //TODO: fetch random channel
            self.fetchRandomChannel { _ in
                _ = self.channelCardView.slideIn(from: .top)
                self.lockButton(false)
            }
        }
    }

    @objc func handleDislikeAction(){
        lockButton(true)

        Service.updateDislikedChannel(userId: UserInfo.user!.id, channelIdx: (recommendingChannel?.channelIdx)!) { result in
            switch result{
            case .success(_):
                break
            case .failure(_):
                self.showMessage(withTitle: "Error", message: "failed to update dislike channel")
            }
        }

        _ = self.channelCardView.slideOut(from: .left) { finished in
            self.fetchRandomChannel { _ in
                _ = self.channelCardView.slideIn(from: .top)
                self.lockButton(false)
            }
        }
    }

    @objc func handleCardViewPanGesture(gesture: UIPanGestureRecognizer){

        switch gesture.state {
        case .began:
            break
        case .changed:
            let translatioon = gesture.translation(in: self.view)
            channelCardView.transform = CGAffineTransform(translationX: translatioon.x, y: 0)
        case .ended, .cancelled:
            let translation = gesture.translation(in: view)
            print(channelCardView.frame)
            if translation.x > 100.adjusted(by: .horizontal) {
                handleLikeAction()
            }else if translation.x < -100.adjusted(by: .horizontal) {
                handleDislikeAction()
            }else{
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
    func handleDetailButton(_ channelCardView: ChannelCardView) {
        let controller = ChannelDetailController(channelId: (recommendingChannel?.channelIdx)!)
        navigationController?.pushViewController(controller, animated: true)
    }
}

