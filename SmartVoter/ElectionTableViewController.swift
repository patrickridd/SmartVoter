//
//  ElectionTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class ElectionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let logo = UIImage(named: "Logo Large")
    let unselectedTabImage = UIImage(named: "Elections")?.imageWithRenderingMode(.AlwaysOriginal)
    let selectedImage = UIImage(named: "ElectionsFilled")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBarItem: UITabBarItem = UITabBarItem(title: "Elections", image: unselectedTabImage, selectedImage: selectedImage)
        self.tabBarItem = customTabBarItem
        
        let logoImageView = UIImageView(image: logo)
        self.navigationItem.titleView = logoImageView
        
        guard let livingAddress = ProfileController.sharedController.loadAddress() else {
            // Present login view controller.
            return
        }
        ElectionController.getContest(livingAddress.asAString) { (contests) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: ProfileViewController.addressChangedNotification, object: nil)
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
        }
    }
}














