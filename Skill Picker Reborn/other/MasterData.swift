//
//  MasterData.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-29.
//

import Foundation

let nullSenior = try! Leader(fName: "null", lName: "senior", cabin: "Unassigned", senior: true)
let nullJunior = try! Leader(fName: "null", lName: "junior", cabin: "Unassigned", senior: false)

var campers: [Camper] = []
var leaders: [Leader] = []
var cabins: [String:Cabin] = [
    "Unassigned": try! Cabin(name: "Unassigned", senior: nullSenior, junior: nullJunior, campers: [])
]
var skills = [
    "None": try! Skill(name: "None", maximums: [255,255,255,255])
]
var fanatics: [String: Fanatic] = [:]

//There is little reason why I should have to resort to doing this.
var importSkillList: [String:Bool] = [:]
var isImporting = false
