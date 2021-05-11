//
//  AppDelegate.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/15.
//

import UIKit
import SwiftRater

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SwiftRater.daysUntilPrompt = 3
        SwiftRater.usesUntilPrompt = 1
        SwiftRater.showLaterButton = true
        SwiftRater.countryCode = "kr"
        SwiftRater.showLog = true
        //TODO: Set debug mode false when lauching app
        SwiftRater.debugMode = true
        SwiftRater.appLaunched()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

