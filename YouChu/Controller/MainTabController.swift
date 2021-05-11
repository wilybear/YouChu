//
//  MainTabController.swift
//  InstagramFireStoreTutorial
//
//  Created by 김현식 on 2021/04/04.
//

import UIKit
import RAMAnimatedTabBarController

class MainTabController: RAMAnimatedTabBarController {

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

        let myPage = templateNavigationController(title:"내 정보" ,unselectedImage: #imageLiteral(resourceName: "profile").withTintColor(.darkGray), selectedImage: #imageLiteral(resourceName: "profile"), rootViewController:  MyPageController())
        let ranking =  templateNavigationController(title:"랭킹", unselectedImage: #imageLiteral(resourceName: "trophy").withTintColor(.darkGray), selectedImage: #imageLiteral(resourceName: "trophy"), rootViewController:  RankingController())
        let home = templateNavigationController(title:"홈",unselectedImage: #imageLiteral(resourceName: "home").withTintColor(.darkGray), selectedImage: #imageLiteral(resourceName: "home"), rootViewController:  HomeController())
        let recommendation =  templateNavigationController(title:"추천",unselectedImage: #imageLiteral(resourceName: "discover").withTintColor(.darkGray), selectedImage: #imageLiteral(resourceName: "discover"), rootViewController:  RecommendationController())

        viewControllers = [home, recommendation, ranking, myPage]
    }

    func templateNavigationController(title: String,unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        let tabBarItem = RAMAnimatedTabBarItem(title: title, image: unselectedImage, selectedImage: selectedImage)
        tabBarItem.animation = RAMFlipLeftTransitionItemAnimations()
        nav.tabBarItem = tabBarItem
        nav.navigationBar.tintColor = .black
       // nav.navigationBar.barTintColor = UIColor.init(named: "soft_red")
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.adjusted(by: .horizontal), weight: .semibold)]
        return nav
    }

}



// MARK: - Properties

// MARK: - LifeCycle

// MARK: - Helpers

// MARK: - Actions
