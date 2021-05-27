//
//  MainTabController.swift
//  InstagramFireStoreTutorial
//
//  Created by 김현식 on 2021/04/04.
//

import UIKit
import GoogleSignIn

class MainTabController: UITabBarController {

    // MARK: - Properties
    private var bounceAnimaton: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfuserIsLoggedIn()
        view.backgroundColor = .white
        setValue(CustomTabbar(frame: tabBar.frame), forKey: "tabBar")
        configureViewControllers()
        tabBar.items?.forEach({$0.imageInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)})
        
    }

    override func viewDidLayoutSubviews() {
        tabBar.itemPositioning = .centered
    }

    // MARK: - Override Functions

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx, let imageView = tabBar.subviews[idx].subviews.compactMap({$0 as? UIImageView}).first else { return }
        imageView.layer.add(bounceAnimaton, forKey: nil)

    }

    // MARK: - API
    func checkIfuserIsLoggedIn(){
        guard let signIn = GIDSignIn.sharedInstance() else { return }
        if (signIn.hasPreviousSignIn()) {
            signIn.restorePreviousSignIn()

        }else{
            DispatchQueue.main.async {
                let controller = GoogleLoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Helpers

    func configureViewControllers(){
        view.backgroundColor = .white
        let myPage = templateNavigationController(title:"내 정보" ,unselectedImage: #imageLiteral(resourceName: "profile"), selectedImage: #imageLiteral(resourceName: "profile"), rootViewController:  MyPageController())
        let ranking =  templateNavigationController(title:"랭킹", unselectedImage: #imageLiteral(resourceName: "trophy"), selectedImage: #imageLiteral(resourceName: "trophy"), rootViewController:  RankingController())
        let home = templateNavigationController(title:"홈",unselectedImage: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"), rootViewController:  HomeController())
        let recommendation =  templateNavigationController(title:"추천",unselectedImage: #imageLiteral(resourceName: "discover"), selectedImage: #imageLiteral(resourceName: "discover"), rootViewController:  RecommendationController())
        viewControllers = [home, recommendation, ranking, myPage]
        tabBar.isTranslucent = false
        tabBar.tintColor = .mainColor_5
        tabBar.unselectedItemTintColor = .mainColor_1
    }

    func templateNavigationController(title: String, unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        return nav
    }
}

//extension MainTabController: SendUserDelegate {
//    func sendUser(user: User) {
//        self.user = user
//    }
//}



// MARK: - Properties

// MARK: - LifeCycle

// MARK: - Helpers

// MARK: - Actions
