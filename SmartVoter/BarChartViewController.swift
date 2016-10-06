//
//  BarChartViewController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/30/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController,  ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var official: Official?
    var candidates: [CandidateID]?
    var months: [String]!
    var contributors: Contributions?
    var organizations: [String]?
    var totals: [Double]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let stateID = ProfileController.sharedController.loadAddress() else { return }
        let myKey = stateID.state.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
        guard let stateAbrev = stateID.stateAbbreviations[myKey] else {return }
        
        CandidateIDController.getCandidateID(stateAbrev) { (candidateIDs) in
            self.candidates = candidateIDs
            self.checkOfficialName()
            
        }
        
        barChartView.delegate = self
        
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
            ContributorController.sharedController.fetchContributors(id, completion: { (contributions) in
                print(contributions)
                self.contributors = contributions
                guard let contributors = contributions,
                    let organizations = contributors.organizations else { return }
                let totals = self.contributors?.totals
                self.organizations = organizations
                
                var totalsAsDouble: [Double] {
                    var totalsArray: [Double] = []
                    guard let totals = totals else { return [] }
                    for total in totals {
                        totalsArray.append(total.doubleValue)
                    }
                    return totalsArray
                }
                self.totals = totalsAsDouble
                self.setChart(organizations, values: totalsAsDouble)
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
        let chartData = BarChartData(xVals: organizations, dataSet: chartDataSet)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.data = chartData
        
    }
  
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) \(organizations![entry.xIndex])")
    }
}
