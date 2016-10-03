//
//  CustomTabBarController.swift
//  SmartVoter
//
//  Created by Brad on 9/26/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let unselectedTabImage1 = UIImage(named: "RepsWhite")?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage1 = UIImage(named: "RepsFilled")
        
        let unselectedTabImage2 = UIImage(named: "Elections")?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage2 = UIImage(named: "ElectionsFilled")
        
        let unselectedTabImage3 = UIImage(named: "Info")?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage3 = UIImage(named: "InfoFilled")?.imageWithRenderingMode(.AlwaysOriginal)
        
        guard let officialsNavController = storyboard?.instantiateViewControllerWithIdentifier("OfficialsNav") else { return }
        let customTabItem1: UITabBarItem = UITabBarItem(title: "Officials", image: unselectedTabImage1, selectedImage: selectedImage1)
        officialsNavController.tabBarItem = customTabItem1
        
        guard let electionsNavController = storyboard?.instantiateViewControllerWithIdentifier("ElectionsNav") else { return }
        let customTabBarItem2: UITabBarItem = UITabBarItem(title: "Elections", image: unselectedTabImage2, selectedImage: selectedImage2)
        electionsNavController.tabBarItem = customTabBarItem2
        
        guard let profileNavController = storyboard?.instantiateViewControllerWithIdentifier("ProfileNav") else { return }
        let customTabBarItem3: UITabBarItem = UITabBarItem(title: "Voter Info", image: unselectedTabImage3, selectedImage: selectedImage3)
        profileNavController.tabBarItem = customTabBarItem3
        
        setViewControllers([officialsNavController, electionsNavController, profileNavController], animated: true)
    }
}
