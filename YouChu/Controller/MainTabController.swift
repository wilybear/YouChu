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

        let myPage = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile"), selectedImage: #imageLiteral(resourceName: "profile"), rootViewController:  MyPageController())
        let ranking =  templateNavigationController(unselectedImage: #imageLiteral(resourceName: "trophy"), selectedImage: #imageLiteral(resourceName: "trophy"), rootViewController:  RankingController())
        let home = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"), rootViewController:  HomeController())
        let recommendation =  templateNavigationController(unselectedImage: #imageLiteral(resourceName: "discover"), selectedImage: #imageLiteral(resourceName: "discover"), rootViewController:  RecommendationController())

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



// MARK: - Properties

// MARK: - LifeCycle

// MARK: - Helpers

// MARK: - Actions
