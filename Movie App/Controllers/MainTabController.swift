//
//  ViewController.swift
//  Twitter-Clone
//
//  Created by Nitin Patil on 17/02/21.
//

import UIKit

class MainTabController: UITabBarController {

    // Mark: - Properties

    // Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        configureViewControllers()
    }
    
    
    // Mark: - Helpers
    

    func configureViewControllers(){
        
        let home = templateNavigationConroller(image: UIImage(named:"home_unselected"), rootViewController: HomeController())
        let search = templateNavigationConroller(image: UIImage(named:"search_unselected"), rootViewController: SearchController())
       viewControllers = [home,search]
    }
    
    func templateNavigationConroller(image:UIImage?,rootViewController:UIViewController)->UIViewController{
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .black
        return nav
        
    }

}

