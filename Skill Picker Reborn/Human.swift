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
    var skillOne = "None"
    var skillTwo = "None"
    var skillThree = "None"
    var skillFour = "None"
    init(fName: String, lName: String, cabin: String) throws {
        self.fName = fName
        self.lName = lName
        self.cabin = cabin
    }
}
