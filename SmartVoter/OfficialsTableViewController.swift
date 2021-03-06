//
//  OfficialsTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class OfficialsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var address: Address?
    let logo = UIImage(named: "TextLogoNoCheck")
    let officialCell = OfficialTableViewCell()
    let unselectedTabImage = UIImage(named: "RepsWhite")?.imageWithRenderingMode(.AlwaysOriginal)
    let selectedImage = UIImage(named: "RepsFilled")
    let rightButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
       
        setRightButton()
        let customTabBarItem: UITabBarItem = UITabBarItem(title: "Officials", image: unselectedTabImage, selectedImage: selectedImage)
        self.tabBarItem = customTabBarItem
        
        let logoImageView = UIImageView(image: logo)
        self.navigationItem.titleView = logoImageView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: SignUpViewController.addressAddedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: ProfileViewController.addressChangedNotification, object: nil)
        
        guard let address = ProfileController.sharedController.loadAddress() else {
            let storyboard = UIStoryboard(name: "PageViewController", bundle: nil)
            guard let pageViewController = storyboard.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController else {return}
            self.presentViewController(pageViewController, animated: true, completion: nil)
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        OfficialController.getOfficials(address.asAString) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false 
            })
        }
    }
    
    
    func setRightButton() {
        let image = UIImage(named: "Settings-100")?.imageWithRenderingMode(.AlwaysTemplate)
        rightButton.tintColor = UIColor.whiteColor()
        rightButton.setImage(image, forState: .Normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightButton.contentMode = .ScaleAspectFit
        rightButton.addTarget(self, action: #selector(presentSettingsTableViewController), forControlEvents: UIControlEvents.TouchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func presentSettingsTableViewController() {
        let storyBoard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsTVC = storyBoard.instantiateViewControllerWithIdentifier("SettingNavigationController")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(settingsTVC, animated: true, completion: nil)
        })
    }
    

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return OfficialController.sortedOfficials.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfficialController.sortedOfficials[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("officialCell", forIndexPath: indexPath) as? OfficialTableViewCell else { return UITableViewCell() }
        
        let official = OfficialController.sortedOfficials[indexPath.section][indexPath.row]
        
        cell.updateOfficialsCell(official)
        cell.updateDefaultImage(official)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String = ""
        
        switch section {
        case 0:
            title = "Federal"
        case 1:
            title = "State"
        case 2:
            title = "Local"
        default:
            title = "Section"
        }
        return title
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let blueColor = UIColor.bradsBlue()
        let font = UIFont(name: "avenir", size: 18)
        
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = blueColor
        header.textLabel?.font = font
        header.textLabel?.textColor = .whiteColor()
    }
    
    func reloadTableView() {
        guard let address = ProfileController.sharedController.loadAddress() else {
            return
        }
        OfficialController.getOfficials(address.asAString) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toOfficialDetail" {
            guard let viewController = segue.destinationViewController as? OfficialDetailTableViewController, indexPath = tableView.indexPathForSelectedRow else { return }
            let official = OfficialController.sortedOfficials[indexPath.section][indexPath.row]
            viewController.official = official
        }
    }
}
