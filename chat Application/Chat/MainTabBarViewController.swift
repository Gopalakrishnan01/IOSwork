//
//  MainTabBarViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 03/11/22.
//

import UIKit


class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground

        
        let storiesVC=UINavigationController(rootViewController: StoriesViewController() )
        let chatsVC=UINavigationController(rootViewController: ChatViewController())
        let settingVC=UINavigationController(rootViewController: ProfileAndSettingsViewController())
        
        
        
        storiesVC.tabBarItem.image=UIImage(named: "reel")
        chatsVC.tabBarItem.image=UIImage(systemName: "ellipsis.message")
        settingVC.tabBarItem.image=UIImage(systemName: "gearshape.fill")
        
        
        tabBar.tintColor = UIColor(red: 85/255, green: 103/255, blue: 198/255, alpha: 1.0)
        tabBar.backgroundColor = .systemBackground
       
        setViewControllers([storiesVC,chatsVC,settingVC], animated: true)
       

        selectedIndex = 1

        
        
        
    }
    

  

}

