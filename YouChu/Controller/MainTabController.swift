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

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfuserIsLoggedIn()
        configureViewControllers()
    }

    // MARK: - API
    func checkIfuserIsLoggedIn(){
        guard let signIn = GIDSignIn.sharedInstance() else { return }
        if (signIn.hasPreviousSignIn()) {
          signIn.restorePreviousSignIn()
          // If you ever changed the client ID you use for Google Sign-in, or
          // requested a different set of scopes, then also confirm that they
          // have the values you expect before proceeding.
          if (signIn.currentUser.authentication.clientID != "235837674630-g4j6mibrsrtiomp5fus179jg796nmt0t.apps.googleusercontent.com"
              // TODO: Implement hasYourRequiredScopes
                || !hasRequiredScope(scope:signIn.currentUser.grantedScopes)) {
            signIn.signOut()
          }
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

    func hasRequiredScope(scope:[Any]) -> Bool {
        return scope.contains{ $0 as! String == "https://www.googleapis.com/auth/youtube.readonly"}
    }


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
       // nav.navigationBar.barTintColor = UIColor.init(named: "soft_red")
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)]
        return nav
    }

}



// MARK: - Properties

// MARK: - LifeCycle

// MARK: - Helpers

// MARK: - Actions
