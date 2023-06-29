//
//  AppDelegate.swift
//  XFlash
//
//  Created by Felix on 06/25/2023.
//  Copyright (c) 2023 Felix. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .black
            appearance.titleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                              NSAttributedString.Key.foregroundColor : UIColor.white]
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

}

