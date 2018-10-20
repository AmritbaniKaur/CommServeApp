//
//  CustomTabBarController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Setup our custom view controllers
        let layout = UICollectionViewFlowLayout()
        // for swiping!!!
        layout.scrollDirection = .horizontal

        let homeController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        homeController.tabBarItem.title = "Home"
        homeController.tabBarItem.image = UIImage(named: "home")
        
        let addPostController = UINavigationController(rootViewController: AddPostController())
        addPostController.tabBarItem.title = "Add Post"
        addPostController.tabBarItem.image = UIImage(named: "Create")
        
        let pinController = UINavigationController(rootViewController: PinController())
        pinController.tabBarItem.title = "Pinned"
        pinController.tabBarItem.image = UIImage(named: "Pinned-icon")
        
        let checkController = UINavigationController(rootViewController: CheckedController())
        checkController.tabBarItem.title = "Completed"
        checkController.tabBarItem.image = UIImage(named: "Checked-icon")
        
        
        let karmController = UINavigationController(rootViewController: KarmaController())
        karmController.tabBarItem.title = "Karma Points"
        karmController.tabBarItem.image = UIImage(named: "Karma-Points")
        
        viewControllers = [checkController, addPostController, homeController, pinController, karmController]
        
        self.tabBar.backgroundColor = UIColor(red:0.16, green:0.28, blue:0.46, alpha:1.0)
        self.tabBar.barTintColor = UIColor(red:0.16, green:0.28, blue:0.46, alpha:1.0)
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.white
        
        self.selectedIndex = 2
 
    }

}
