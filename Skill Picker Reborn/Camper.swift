//
//  Camper.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Camper: Human {
    var preferredSkills: [String]
    init(fName: String, lName: String, cabin: String, preferredSkills: [String]) throws {
        if(preferredSkills.count != 6){
            throw ValueError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
        try! super.init(fName: fName, lName: lName, cabin: cabin)
    }
}
