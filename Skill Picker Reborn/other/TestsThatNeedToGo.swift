//
//  TestsThatNeedToGo.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import Foundation

let fooPreferredSkills = ["Archery","Backcountry","Pelletry","Ultimate","Crafts","Drama"]
let fooFanPrefSkills = ["Volleyball","Wall","Horses","Swimming","Drama"]
var fooCampers = [
    try! Camper(fName: "Joe", lName: "Biden", cabin: "1", preferredSkills: fooPreferredSkills, fanatic: "None", skills: ["Archery",
                                                                                                                         "None",
                                                                                                                         "None",
                                                                                                                         "None"]),
    try! Camper(fName: "Donald", lName: "Trump", cabin: "2", preferredSkills: fooFanPrefSkills, fanatic: "Paintball", skills: ["Archery",
                                                                                                                               "None",
                                                                                                                               "Paintball",
                                                                                                                               "Paintball"]),
    try! Camper(fName: "Snoop", lName: "Dogg", cabin: "2", preferredSkills: fooPreferredSkills, fanatic: "None", skills: ["None",
                                                                                                                          "None",
                                                                                                                          "Backcountry",
                                                                                                                          "None"]),
    try! Camper(fName: "Hilary", lName: "Clinton", cabin: "A", preferredSkills: fooFanPrefSkills, fanatic: "Paintball", skills: ["None",
                                                                                                                                 "None",
                                                                                                                                 "Paintball",
                                                                                                                                 "Paintball"]),
    try! Camper(fName: "Doja", lName: "Cat", cabin: "A", preferredSkills: fooPreferredSkills, fanatic: "None", skills: ["None",
                                                                                                                        "None",
                                                                                                                        "Backcountry",
                                                                                                                        "None"])
]

var fooLeaders = [
    try! Leader(fName: "Dirty", lName: "Harry", cabin: "1", senior: true, skills: ["None",
                                                                                   "None",
                                                                                   "Backcountry",
                                                                                   "None"]),
    try! Leader(fName: "Hugh", lName: "Jazz", cabin: "1", senior: false, skills: ["Archery",
                                                                                  "None",
                                                                                  "None",
                                                                                  "None"]),
    try! Leader(fName: "Peter", lName: "Griffin", cabin: "2", senior: true, skills: ["Archery",
                                                                                     "None",
                                                                                     "None",
                                                                                     "None"]),
    try! Leader(fName: "Mike", lName: "Ox", cabin: "2", senior: false),
    try! Leader(fName: "Lois", lName: "Griffin", cabin: "A", senior: true),
    try! Leader(fName: "Anna", lName: "Borshin", cabin: "A", senior: false, skills: ["None",
                                                                                     "None",
                                                                                     "Backcountry",
                                                                                     "None"])
]
var fooCabins = [
    "Unassigned": try! Cabin(name: "Unassigned", senior: nullSenior, junior: nullJunior, campers: []),
    "1": try! Cabin(name: "1", senior: fooLeaders[0], junior: fooLeaders[1], campers: [fooCampers[0]]),
    "2": try! Cabin(name: "2", senior: fooLeaders[2], junior: fooLeaders[3], campers: [fooCampers[1],fooCampers[2]]),
    "A": try! Cabin(name: "A", senior: fooLeaders[4], junior: fooLeaders[5], campers: [fooCampers[3],fooCampers[4]])
]

var fooSkills = [
    "None": try! Skill(name: "None", leaders: [[],
                                               [],
                                               [],
                                               []], maximums: [255,255,255,255]),
    "Archery": try! Skill(name: "Archery", periods: [[fooCampers[0],fooCampers[1]],
                                                     [],
                                                     [],
                                                     []],
                    leaders: [[fooLeaders[2],fooLeaders[1]],
                              [],
                              [],
                              []], maximums: [10,10,10,10]),
    "Backcountry": try! Skill(name: "Backcountry", periods: [[],
                                                             [],
                                                             [fooCampers[4],fooCampers[2]],
                                                             []],
                        leaders: [[],
                                  [],
                                  [fooLeaders[0],fooLeaders[5]],
                                  []], maximums: [10,10,10,10]),
    "Paintball": try! Skill(name: "Paintball", periods: [[],
                                                        [],
                                                        [fooCampers[1],fooCampers[3]],
                                                        [fooCampers[1],fooCampers[3]]],
                          leaders: [[],
                                    [],
                                    [],
                                    []], maximums: [0,0,20,20])
    
]

var fooFanatics = [
    //"Tabletop Adventure": try! Fanatic(name: "Tabletop Adventure", activePeriods: [true, true, false, false]),
    "Paintball": try! Fanatic(name: "Paintball", activePeriods: [false, false, true, true])
]
