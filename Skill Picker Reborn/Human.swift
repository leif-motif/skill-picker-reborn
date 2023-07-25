//
//  Human.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-23.
//

import Foundation

let validCabins: [String] = ["A","B","C","D","E","F","1","2","3","4","5"]
enum ValueError: Error {
    case OutOfRange
    case InvalidValue
    case InvalidSize
    case TooManySkills
}

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
