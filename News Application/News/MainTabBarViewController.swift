//
//  MainTabBarViewController.swift
//  News
//
//  Created by zs-mac-6 on 14/11/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        let sb=UIStoryboard(name: "Main", bundle: nil)
        
        
        let headlineVC=sb.instantiateViewController(withIdentifier: "HeadlineViewController")
        
        let vc1=UINavigationController(rootViewController: ForYouViewController())
        let vc2=UINavigationController(rootViewController: headlineVC)
        vc2.navigationBar.prefersLargeTitles = true
        let vc3=UINavigationController(rootViewController: CategorySelectionViewController())

        
        vc1.tabBarItem.image=UIImage(systemName:"diamond.fill")
        vc2.tabBarItem.image=UIImage(systemName:"globe")
        vc3.tabBarItem.image=UIImage(systemName:"play.square.fill")

        vc1.title="For you"
        vc2.title="Headlines"
        vc3.title="category"

        
        
        tabBar.tintColor = UIColor(named: "tabBar")
                
        setViewControllers([vc1,vc2,vc3], animated: true)
        selectedIndex=1
                
                
               
    }
    

    

}
