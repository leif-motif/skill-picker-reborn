//
//  Human.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-23.
//

import Foundation

class Human: Identifiable {
    let id = UUID()
    let fName: String
    let lName: String
    let cabin: String
    var skillOne = "None"
    var skillTwo = "None"
    var skillThree = "None"
    var skillFour = "None"
    init(fName: String, lName: String, cabin: String) throws {
        self.fName = fName
        self.lName = lName
        if(!validCabins.contains(cabin)){
            throw ValueError.InvalidValue
        } else {
            self.cabin = cabin
        }
    }
}
