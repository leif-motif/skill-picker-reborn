//
//  Camper.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Camper: Human {
    var preferredSkills: [String]
    var fanatic: String
    init(fName: String, lName: String, cabin: String, preferredSkills: [String], fanatic: String, skills: [String] = ["None", "None", "None", "None"]) throws {
        self.fanatic = fanatic
        if((preferredSkills.count != 6 && fanatic == "None") || (preferredSkills.count != 5 && fanatic != "None")){
            throw SPRError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
        try! super.init(fName: fName, lName: lName, cabin: cabin, skills: skills)
    }
}
