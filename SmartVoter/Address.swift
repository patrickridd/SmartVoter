//
//  Address.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

struct Address {

    var line1: String
    var city: String
    var state: String
    var zip: String
    
    var asAString: String {
        return "\(line1), \(city.capitalizedString), \(state), \(zip)"
    }
    
    init(line1: String, city: String, state: String, zip: String) {
        self.line1 = line1
        self.city = city
        self.state = state
        self.zip = zip
    }
    
    
    enum State: String {
        case Alabama = "Alabama"
        case Alaska = "Alaska"
        case Arizona = "Arizona"
        case Arkansas = "Arkansas"
        case California = "California"
        case Colorado = "Colorado"
        case Connecticut = "Connecticut"
        case Delaware = "Delware"
        case Florida = "Florida"
        case Georgia = "Georgia"
        case Hawaii = "Hawaii"
        case Idaho = "Idaho"
        case Illinois = "Illinois"
        case Indiana = "Indiana"
        case Iowa = "Iowa"
        case Kansas = "Kansas"
        case Kentucky = "Kentucky"
        case Louisiana = "Louisiana"
        case Maine = "Main"
        case Maryland = "Maryland"
        case Massachusetts = "Massachusetts"
        case Michigan = "Michigan"
        case Minnesota = "Minnesota"
        case Mississippi = "Mississippi"
        case Missouri = "Missouri"
        case Montana = "Montana"
        case Nebraska = "Nebraska"
        case Nevada = "Nevada"
        case NewHampshire = "New Hampshire"
        case NewJersey = "New Jersey"
        case NewMexico = "New Mexico"
        case NewYork = "New York"
        case NorthCarolina = "North Carolina"
        case NorthDakota = "North Dakota"
        case Ohio = "Ohio"
        case Oklahoma = "Oklahoma"
        case Oregon = "Oregon"
        case Pennsylvania = "Pennsylvania"
        case RhodeIsland = "Rhode Island"
        case SouthCarolina = "South Carolina"
        case SouthDakota = "South Dakota"
        case Tennessee = "Tennessee"
        case Texas = "Texas"
        case Utah = "Utah"
        case Vermont = "Vermont"
        case Virginia = "Virginia"
        case Washington = "Washington"
        case WestVirginia = "West Virginia"
        case Wisconsin = "Wisconsin"
        case Wyoming = "Wyoming"
    
    }
    
    static let states: [State] = [.Alabama, .Alaska, .Arizona, .Arkansas, .California, .Colorado, .Connecticut, .Delaware, .Florida, .Georgia, .Hawaii, .Idaho, .Illinois, .Indiana, .Iowa, .Kansas,
                                  .Kentucky, .Louisiana, .Maine, .Maryland, .Massachusetts, .Michigan, .Minnesota, .Mississippi, .Missouri, .Montana, .Nebraska, .Nevada, .NewHampshire, .NewJersey,
                                  .NewMexico, .NewYork, .NorthCarolina, .NorthDakota, .Ohio, .Oklahoma, .Oregon, .Pennsylvania, .RhodeIsland, .SouthCarolina, .SouthDakota, .Tennessee, .Texas, .Utah,
                                  .Vermont, .Virginia, .Washington, .WestVirginia, .Wisconsin, .Wyoming]
    
}
















