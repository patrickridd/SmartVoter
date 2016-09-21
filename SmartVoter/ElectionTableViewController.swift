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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let livingAddress = ProfileController.sharedController.loadAddress() else {
//            // Present login view controller.
//            return
//        }
        ElectionController.getContest("1566 East Evergreen Lane, 84106, SLC, Utah") { (contests) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ElectionController.elections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("electionCell", forIndexPath: indexPath) as? ElectionTableViewCell else { return UITableViewCell() }
        let contest = ElectionController.elections[indexPath.row]
        
        cell.updateWithElection(contest)
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toElectionDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? ElectionDetailViewController, indexPath = tableView.indexPathForSelectedRow else { return }
            let contest = ElectionController.elections[indexPath.row]
            destinationVC.contest = contest
        }
    }
}














