//
//  MainTabBarController.swift
//  TaxScan
//
//  Created by Gadirli on 06.09.23.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBars()
    }
    

    private func configureBars(){
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        
        let vc2 = UINavigationController(rootViewController: SettingsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBar.tintColor = .white
        tabBar.backgroundColor = .black
        setViewControllers([vc1, vc2], animated: true)
    }

}
