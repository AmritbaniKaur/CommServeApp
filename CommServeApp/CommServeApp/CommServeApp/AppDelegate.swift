//
//  AppDelegate.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    let defaults = UserDefaults.standard
    var userIsLoggedIn: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.window = UIWindow()
        FirebaseApp.configure()
        
        self.window?.makeKeyAndVisible()
        
        //let loginController = UINavigationController(rootViewController: LoginController())
        userIsLoggedIn = defaults.bool(forKey: "UserIsLoggedIn")
        UINavigationBar.appearance().barTintColor = UIColor(red:0.16, green:0.28, blue:0.46, alpha:1.0)
        //UINavigationBar.appearance().barTintColor = UIColor(red:1.00, green:0.42, blue:0.00, alpha:1.0)
        let textcolor = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = textcolor
        
        application.statusBarStyle = .lightContent
        //application.statusBarStyle = .default
        
        /*
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor(red:0.82, green:0.45, blue:0.20, alpha:1.0)
        
        window?.addSubview(statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "V:|[v0(20)]|", views: statusBarBackgroundView)
        */
        
        if userIsLoggedIn == true
        {
            window?.rootViewController = CustomTabBarController()
        }
        else
        {
            // Swiping Welcome CollectionView
            let layout = UICollectionViewFlowLayout()
            // for swiping!!!
            layout.scrollDirection = .horizontal
            let swipingController = WelcomeController(collectionViewLayout: layout)
            let NavSwipe = UINavigationController(rootViewController: swipingController)

            window?.rootViewController = NavSwipe
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

