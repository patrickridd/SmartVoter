//
//  ElectionDetailViewController.swift
//  SmartVoter
//
//  Created by Brad on 9/21/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class ElectionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var electionTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var contest: Contest?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        guard let contest = contest else { return }
        
        if contest.type == "General" {
            electionTypeLabel.text = contest.office
            descriptionLabel.text = contest.scope.capitalizedString
        } else if contest.type == "Referendum" {
            electionTypeLabel.text = contest.referendumTitle?.capitalizedString
            descriptionLabel.text = contest.referendumSubtitle?.capitalizedString
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contest = contest, candidates = contest.candidates else { return 0 }
        return candidates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("candidateCell"), contest = contest, candidates = contest.candidates else { return UITableViewCell() }

        let candidate = candidates[indexPath.row]
        
        cell.textLabel?.text = candidate.name
        cell.detailTextLabel?.text = candidate.party
        
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    */
}









