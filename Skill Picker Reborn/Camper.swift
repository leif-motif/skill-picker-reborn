//
//  Camper.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Camper: Human {
    let preferredSkills: [String]
    var fanatic: String
    init(fName: String, lName: String, cabin: String, preferredSkills: [String], fanatic: String, skillOne: String = "None", skillTwo: String = "None", skillThree: String = "None", skillFour: String = "None") throws {
        self.fanatic = fanatic
        if((preferredSkills.count != 6 && fanatic == "None") || (preferredSkills.count != 5 && fanatic != "None")){
            throw ValueError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
        try! super.init(fName: fName, lName: lName, cabin: cabin, skillOne: skillOne, skillTwo: skillTwo, skillThree: skillThree, skillFour: skillFour)
    }
}
