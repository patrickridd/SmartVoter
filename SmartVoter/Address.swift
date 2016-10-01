//
//  Address.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class Address: NSObject, NSCoding {
    
    var line1: String
    var city: String
    var state: String
    var zip: String
    
    init(line1: String, city: String, state: String, zip: String) {
        self.line1 = line1
        self.city = city
        self.state = state
        self.zip = zip
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let line1 = aDecoder.decodeObjectForKey("line1") as? String,
            let city = aDecoder.decodeObjectForKey("city") as? String,
            let state = aDecoder.decodeObjectForKey("state") as? String,
            let zip = aDecoder.decodeObjectForKey("zip") as? String else { return nil }
        self.init(line1: line1, city: city, state: state, zip: zip)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.line1, forKey: "line1")
        aCoder.encodeObject(self.city, forKey: "city")
        aCoder.encodeObject(self.state, forKey: "state")
        aCoder.encodeObject(self.zip, forKey: "zip")
    }
    
    var asAString: String {
        return "\(line1), \(city.capitalizedString), \(state), \(zip)"
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
        case Maine = "Maine"
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
    
    static let states: [State] = [.Alabama, .Alaska, .Arizona, .Arkansas, .California,
                                  .Colorado, .Connecticut, .Delaware, .Florida, .Georgia,
                                  .Hawaii, .Idaho, .Illinois, .Indiana, .Iowa,
                                  .Kansas, .Kentucky, .Louisiana, .Maine, .Maryland,
                                  .Massachusetts, .Michigan, .Minnesota, .Mississippi, .Missouri,
                                  .Montana, .Nebraska, .Nevada, .NewHampshire, .NewJersey,
                                  .NewMexico, .NewYork, .NorthCarolina, .NorthDakota, .Ohio,
                                  .Oklahoma, .Oregon, .Pennsylvania, .RhodeIsland, .SouthCarolina,
                                  .SouthDakota, .Tennessee, .Texas, .Utah, .Vermont,
                                  .Virginia, .Washington, .WestVirginia, .Wisconsin, .Wyoming]
    
    enum StateAbbreviations: String {
        case Alabama = "AL"
        case Alaska = "AK"
        case Arizona = "AZ"
        case Arkansas = "AR"
        case California = "CA"
        case Colorado = "CO"
        case Connecticut = "CT"
        case Delaware = "DE"
        case Florida = "FL"
        case Georgia = "GA"
        case Hawaii = "HI"
        case Idaho = "ID"
        case Illinois = "IL"
        case Indiana = "IN"
        case Iowa = "IA"
        case Kansas = "KS"
        case Kentucky = "KY"
        case Louisiana = "LA"
        case Maine = "ME"
        case Maryland = "MD"
        case Massachusetts = "MA"
        case Michigan = "MI"
        case Minnesota = "MN"
        case Mississippi = "MS"
        case Missouri = "Missouri"
        case Montana = "MT"
        case Nebraska = "NE"
        case Nevada = "NV"
        case NewHampshire = "NH"
        case NewJersey = "NJ"
        case NewMexico = "NM"
        case NewYork = "NY"
        case NorthCarolina = "NC"
        case NorthDakota = "ND"
        case Ohio = "OH"
        case Oklahoma = "OK"
        case Oregon = "OR"
        case Pennsylvania = "PA"
        case RhodeIsland = "RI"
        case SouthCarolina = "SC"
        case SouthDakota = "SD"
        case Tennessee = "TN"
        case Texas = "TX"
        case Utah = "UT"
        case Vermont = "VT"
        case Virginia = "VA"
        case Washington = "WA"
        case WestVirginia = "WV"
        case Wisconsin = "WI"
        case Wyoming = "WY"
    }
}


















