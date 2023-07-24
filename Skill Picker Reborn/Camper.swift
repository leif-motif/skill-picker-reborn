//
//  Camper.swift
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
}

class Camper: Identifiable {
    let id = UUID()
    let fName: String
    let lName: String
    let cabin: String
    private let preferredSkills: [String]
    var skillOne = "None"
    var skillTwo = "None"
    var skillThree = "None"
    var skillFour = "None"
    func getPreferredSkill(priority: Int) throws -> String {
        if(priority < 1 || priority > 6){
            throw ValueError.OutOfRange
        }
        return self.preferredSkills[priority-1]
    }
    init(fName: String, lName: String, cabin: String, preferredSkills: [String]) throws {
        self.fName = fName
        self.lName = lName
        if(!validCabins.contains(cabin)){
            throw ValueError.InvalidValue
        } else {
            self.cabin = cabin
        }
        if(preferredSkills.count != 6){
            throw ValueError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
    }
}
