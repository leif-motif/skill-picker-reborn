//
//  Leader.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Leader: Human {
    let senior: Bool
    init(fName: String, lName: String, cabin: String = "Unassigned", senior: Bool, skills: [String] = ["None", "None", "None", "None"]) throws {
        self.senior = senior
        try! super.init(fName: fName, lName: lName, cabin: cabin, skills: skills)
    }
}
