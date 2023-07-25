//
//  Camper.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Camper: Human {
    private let preferredSkills: [String]
    func getPreferredSkill(priority: Int) throws -> String {
        if(priority < 1 || priority > 6){
            throw ValueError.OutOfRange
        }
        return self.preferredSkills[priority-1]
    }
    init(fName: String, lName: String, cabin: String, preferredSkills: [String]) throws {
        if(preferredSkills.count != 6){
            throw ValueError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
        try! super.init(fName: fName, lName: lName, cabin: cabin)
    }
}
