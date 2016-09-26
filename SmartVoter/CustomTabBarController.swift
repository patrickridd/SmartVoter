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
        
        let unselectedTabImage = UIImage(named: "Elections")?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: "ElectionsFilled")
        
        let unselectedTabImage3 = UIImage(named: "Profile")?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage3 = UIImage(named: "ProfileFilled")
        
        guard let officialsNavController = storyboard?.instantiateViewControllerWithIdentifier("OfficialsNav") else { return }
        let customTabItem1: UITabBarItem = UITabBarItem(title: "Officials", image: unselectedTabImage1, selectedImage: selectedImage1)
        officialsNavController.tabBarItem = customTabItem1
        
        guard let electionsNavController = storyboard?.instantiateViewControllerWithIdentifier("ElectionsNav") else { return }
        let customTabBarItem: UITabBarItem = UITabBarItem(title: "Elections", image: unselectedTabImage, selectedImage: selectedImage)
        electionsNavController.tabBarItem = customTabBarItem
        
        guard let profileNavController = storyboard?.instantiateViewControllerWithIdentifier("ProfileNav") else { return }
        let customTabBarItem3: UITabBarItem = UITabBarItem(title: "Profile", image: unselectedTabImage3, selectedImage: selectedImage3)
        
        profileNavController.tabBarItem = customTabBarItem3
        setViewControllers([officialsNavController, electionsNavController, profileNavController], animated: true)
    }

}
