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
        view.backgroundColor = .white
        UserInfo.fetchUser(userId: 16) { result in
            switch result {
            case .success(_):
                self.configureViewControllers()
            case .failure(_):
                self.showMessage(withTitle: "에러", message: "올바르지 않은 접근입니다.")
            }
        }
    }

    // MARK: - API

    // MARK: - Helpers

    func configureViewControllers(){
        view.backgroundColor = .white

        let myPage = templateNavigationController(title:"내 정보" ,image: #imageLiteral(resourceName: "profile"), rootViewController:  MyPageController())
        let ranking =  templateNavigationController(title:"랭킹", image: #imageLiteral(resourceName: "trophy"), rootViewController:  RankingController())
        let home = templateNavigationController(title:"홈",image: #imageLiteral(resourceName: "home"), rootViewController:  HomeController())
        let recommendation = templateNavigationController(title:"추천",image: #imageLiteral(resourceName: "discover"), rootViewController:  RecommendationController())

        viewControllers = [home, recommendation, ranking, myPage]
        tabBar.isTranslucent = false
        tabBar.barTintColor  = .white

    }

    func templateNavigationController(title: String, image: UIImage, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = RAMAnimatedTabBarItem(title: title, image: image, tag: 0, animation: RAMFlipLeftTransitionItemAnimations(), selectedColor: .mainColor_5, unselectedColor: .mainColor_1)
        nav.tabBarItem = tabBarItem
       // nav.navigationBar.barTintColor = UIColor.init(named: "soft_red")
        nav.navigationBar.isTranslucent = false
        nav.navigationController?.navigationBar.backgroundColor = .red
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.adjusted(by: .horizontal), weight: .semibold)]
        return nav
    }

}



// MARK: - Properties

// MARK: - LifeCycle

// MARK: - Helpers

// MARK: - Actions
