//
//  Camper.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Camper: Human {
    var preferredSkills: [String]
    init(fName: String, lName: String, cabin: String, preferredSkills: [String] = ["","","","","",""], skillOne: String = "None", skillTwo: String = "None", skillThree: String = "None", skillFour: String = "None") throws {
        if(preferredSkills.count != 6){
            throw ValueError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
        try! super.init(fName: fName, lName: lName, cabin: cabin, skillOne: skillOne, skillTwo: skillTwo, skillThree: skillThree, skillFour: skillFour)
    }
}
