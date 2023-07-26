//
//  Human.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-23.
//

import Foundation

class Human: Identifiable {
    let id = UUID()
    var fName: String
    var lName: String
    var cabin: String
    var skillOne: String
    var skillTwo: String
    var skillThree: String
    var skillFour: String
    init(fName: String, lName: String, cabin: String = "Unassigned", skillOne: String = "None", skillTwo: String = "None", skillThree: String = "None", skillFour: String = "None") throws {
        self.fName = fName
        self.lName = lName
        self.cabin = cabin
        self.skillOne = skillOne
        self.skillTwo = skillTwo
        self.skillThree = skillThree
        self.skillFour = skillFour
    }
}
