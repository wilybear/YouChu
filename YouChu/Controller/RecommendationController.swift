//
//  RecommendationController.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//


import UIKit

class RecommendationController: UIViewController {

    // MARK: - Properties

    private let channelCardView: UIView = {
        let view = ChannelCardView()

        return view
    }()

    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 채널은 어떠세요?"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()

    private let likeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .systemPink
        return button
    }()

    private let dislikeButton: UIButton = {
        let button = CircularShadowButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_close").withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.layerBackgroundColor = .systemGray
        return button
    }()



    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        stack.setDimensions(height: 60, width: 140)
        stack.setCustomSpacing(20, after: dislikeButton)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)


        view.addSubview(channelCardView)
        channelCardView.anchor(top:helpLabel.bottomAnchor, left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor ,paddingTop: 20, paddingLeft: 50, paddingBottom: 20, paddingRight: 50)


    }


}

// MARK: DumiData

extension RecommendationController {
    func fetchData() -> [String]{
        return ["승우 아빠", "Black Pink - Official channel"]
    }
}
