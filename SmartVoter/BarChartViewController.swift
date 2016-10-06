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
        barChartView.noDataTextDescription = "Were sorry, we couldn't find any fundraising data for this official"
        
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
        barChartView.descriptionText = ""
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Money provided in US Dollars")
        let chartData = BarChartData(xVals: organizations, dataSet: chartDataSet)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.labelPosition = .BothSided
        chartDataSet.colors = ChartColorTemplates.liberty()
        let yaxis = barChartView.getAxis(ChartYAxis.AxisDependency.Right)
        yaxis.drawLabelsEnabled = false
        barChartView.data = chartData
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) \(organizations![entry.xIndex])")
    }
    
    @IBAction func saveChart(sender: AnyObject) {
        let bounds = UIScreen.mainScreen().bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
}

