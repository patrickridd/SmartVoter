//
//  BarChartViewController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/30/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var official: Official?
    var candidates: [CandidateID]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let stateID = ProfileController.sharedController.loadAddress() else { return }
        let myKey = stateID.state.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
        guard let stateAbrev = stateID.stateAbbreviations[myKey] else {return }
        
        CandidateIDController.getCandidateID(stateAbrev) { (candidateIDs) in
            self.candidates = candidateIDs
            checkOfficialName()
        }
        
        
        
        
        func checkOfficialName() {
            guard let officialName = official?.name,
                let candidates = self.candidates else {
                    return
            }
            
            let matchingCandidates = candidates.filter{$0.fullName == officialName}
            if let candidate = matchingCandidates.first,
                let id = candidate.candidateId
            {
                ContributorController.sharedController.fetchContributors(id, completion: { (contributoins) in
                    print(contributoins)
                })
                
            }
            
        }
        
        
}
