//
//  MasterData.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-29.
//

import Foundation

let nullSenior = try! Leader(fName: "null", lName: "senior", cabin: "Unassigned", senior: true)
let nullJunior = try! Leader(fName: "null", lName: "junior", cabin: "Unassigned", senior: false)

class CampData: ObservableObject {
    @Published var campers: [Camper]
    @Published var leaders: [Leader]
    @Published var cabins: [String:Cabin]
    @Published var skills: [String:Skill]
    @Published var fanatics: [String:Fanatic]
    
    init(campers: [Camper] = [], leaders: [Leader] = [],
         cabins: [String:Cabin] = ["Unassigned": try! Cabin(name: "Unassigned", senior: nullSenior, junior: nullJunior, campers: [])],
         skills: [String:Skill] = ["None": try! Skill(name: "None", maximums: [255,255,255,255])], fanatics: [String:Fanatic] = [:]){
        self.campers = campers
        self.leaders = leaders
        self.cabins = cabins
        self.skills = skills
        self.fanatics = fanatics
    }
}

//There is little reason why I should have to resort to doing this.
var importSkillList: [String:Bool] = [:]
var isImporting = false
