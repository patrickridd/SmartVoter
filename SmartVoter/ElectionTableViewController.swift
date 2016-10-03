//
//  ElectionTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import SafariServices

class ElectionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContestView: UIView!
    
    let rightButton = UIButton()
    let logo = UIImage(named: "TextLogoNoCheck")
    let unselectedTabImage = UIImage(named: "Elections")?.imageWithRenderingMode(.AlwaysOriginal)
    let selectedImage = UIImage(named: "ElectionsFilled")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = ContributorController() 
        setRightButton()
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableViewAutomaticDimension
        let customTabBarItem: UITabBarItem = UITabBarItem(title: "Elections", image: unselectedTabImage, selectedImage: selectedImage)
        self.tabBarItem = customTabBarItem
        self.noContestView.hidden = true
        let logoImageView = UIImageView(image: logo)
        self.navigationItem.titleView = logoImageView
        
        guard let livingAddress = ProfileController.sharedController.loadAddress() else {
            // Present login view controller.
            return
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ElectionController.getContest(livingAddress.asAString) { (contests) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if contests?.count == 0 || contests == nil {
                    self.presentNoContestsView()
                }
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: ProfileViewController.addressChangedNotification, object: nil)
    }
    
    @IBAction func clickHereButtonTapped(sender: AnyObject) {
        guard let url = NSURL(string: "https://developers.google.com/civic-information/docs/civic_info_api_data_availability_schedule.pdf") else {
            return
        }
        let safariVC = SFSafariViewController(URL: url)
        if #available(iOS 10.0, *) {
            safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
        } else {
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(safariVC, animated: true, completion: nil)
        })
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

    
    func presentNoContestsView() {
        self.noContestView.hidden = false
    }

    
    // MARK: - Table view data source
    
    func reloadTableView() {
        guard let livingAddress = ProfileController.sharedController.loadAddress() else {
            // Present login view controller.
            return
        }
        ElectionController.getContest(livingAddress.asAString) { (contests) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ElectionController.sortedContests.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ElectionController.sortedContests[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("electionCell", forIndexPath: indexPath) as? ElectionTableViewCell else { return UITableViewCell() }
        let contest = ElectionController.sortedContests[indexPath.section][indexPath.row]
        
        cell.updateWithElection(contest)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            performSegueWithIdentifier("toElectionDetailSegue", sender: self)
        } else {
            performSegueWithIdentifier("toReferendumDetailSegue", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String = ""
        
        switch section {
        case 0:
            title = "Elections"
        case 1:
            title = "Referendums"
        default:
            title = "Contests"
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toElectionDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? ElectionDetailViewController, indexPath = tableView.indexPathForSelectedRow else { return }
            let contest = ElectionController.sortedContests[indexPath.section][indexPath.row]
            destinationVC.contest = contest
        } else if segue.identifier == "toReferendumDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? ReferendumDetailViewController, indexPath = tableView.indexPathForSelectedRow else { return }
            let contest = ElectionController.sortedContests[indexPath.section][indexPath.row]
            destinationVC.contest = contest
        }
    }
}














