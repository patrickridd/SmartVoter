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

<<<<<<< HEAD
        ElectionController.getContest("2026 terra linda drive, 84124, Holladay, Utah") { (contests) in
=======
        ElectionController.getContest("1566 East Evergreen Lane 84106, Salt Lake City Utah") { (contests) in
            
            
>>>>>>> feature/PollingController
        }
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ElectionController.elections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("electionCell", forIndexPath: indexPath) as? ElectionTableViewCell
        
        cell?.updateWithElection()
        
        return cell ?? UITableViewCell()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
