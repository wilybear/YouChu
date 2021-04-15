//
//  MainTabController.swift
//  InstagramFireStoreTutorial
//
//  Created by 김현식 on 2021/04/04.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    // MARK: - API

    // MARK: - Helpers

    func configureViewControllers(){
        view.backgroundColor = .white

        let myPage = MyPageController()
        let ranking = RankingController()
        let home = HomeController()
        let recommendation = RecommendationController()

        viewControllers = [home, recommendation, ranking, myPage]
    }

    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }

}
