//
//  Leader.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Leader: Human {
    let senior: Bool
    init(fName: String, lName: String, cabin: String = "Unassigned", senior: Bool, skillOne: String = "None", skillTwo: String = "None", skillThree: String = "None", skillFour: String = "None") throws {
        self.senior = senior
        try! super.init(fName: fName, lName: lName, cabin: cabin, skillOne: skillOne, skillTwo: skillTwo, skillThree: skillThree, skillFour: skillFour)
    }
}
