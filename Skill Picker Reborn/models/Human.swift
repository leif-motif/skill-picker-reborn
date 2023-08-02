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
    var skills: [String]
    init(fName: String, lName: String, cabin: String = "Unassigned", skills: [String] = ["None", "None", "None", "None"]) throws {
        //I am not taking any chances with spaces. Cope. Seethe.
        self.fName = fName.replacingOccurrences(of: " ", with: "")
        self.lName = lName.replacingOccurrences(of: " ", with: "")
        self.cabin = cabin
        if(skills.count != 4){
            throw SPRError.InvalidSize
        }
        self.skills = skills
    }
}
