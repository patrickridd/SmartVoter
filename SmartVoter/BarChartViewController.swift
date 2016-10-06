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
    var months: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let stateID = ProfileController.sharedController.loadAddress() else { return }
        let myKey = stateID.state.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
        guard let stateAbrev = stateID.stateAbbreviations[myKey] else {return }
        
        CandidateIDController.getCandidateID(stateAbrev) { (candidateIDs) in
            self.candidates = candidateIDs
            
        }
        checkOfficialName()
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(months, values: unitsSold)
        
        
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Money Spent")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        
    }
}
