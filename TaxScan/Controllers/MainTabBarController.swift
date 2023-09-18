//
//  MainTabBarController.swift
//  TaxScan
//
//  Created by Gadirli on 06.09.23.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureBars()
    }
    
    // MARK: Helpers
    
    private func configureBars(){
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        
        let vc2 = UINavigationController(rootViewController: SettingsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
        setViewControllers([vc1, vc2], animated: true)
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }

}
