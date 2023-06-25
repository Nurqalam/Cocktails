//
//  AppDelegate.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let launchScreenViewController = LaunchScreenViewController()
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let mainViewController = MainViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            self.window?.rootViewController = navigationController
        }

        return true
    }
}

